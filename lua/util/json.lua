local M = {}

local json_path_ns = vim.api.nvim_create_namespace("json_path")

function M.show_json_path()
  local line_len = vim.fn.col("$")
  if line_len > 1000 then return end


  local current_line = vim.fn.line(".") - 1
  local buf = vim.api.nvim_get_current_buf()
  local json_path = require("jsonpath").get(nil, buf)

  if vim.fn.exists("*nvim_buf_set_extmark") then
    vim.api.nvim_buf_clear_namespace(buf, json_path_ns, 0, -1)
    vim.api.nvim_buf_set_extmark(buf, json_path_ns, current_line, 0, {
      virt_text = { { json_path, "Comment" } },
      virt_text_pos = "eol",
      hl_mode = "replace",
      hl_group = "Comment"
    })
  end
end

-- Stolen from https://github.com/mogelbrod/vim-jsonpath

---@class LinesScanner
---@field line number
---@field col number
---@field lines string[]
local LinesScanner = {}
---@param lines string[]
function LinesScanner:new(lines)
  local o = { line = 1, col = 1, lines = lines }
  setmetatable(o, self)
  self.__index = self
  return o
end

---@return string | nil
function LinesScanner:next()
  if self.line > #self.lines then return nil end
  local line = self.lines[self.line]
  local char = line:sub(self.col, self.col)
  self.col = self.col + 1
  if self.col > #line then
    self.col = 1
    self.line = self.line + 1
  end
  return char
end

---@return string | nil
function LinesScanner:peek()
  if self.line > #self.lines then return nil end
  local line = self.lines[self.line]
  return line:sub(self.col, self.col)
end

---@return number, number
function LinesScanner:pos()
  return self.line, self.col
end

---@param scanner LinesScanner
local function read_utf(scanner)
  local code = 0
  for i in 3, 0, -1 do
    local num = tonumber(scanner:next(), 16)
    if num == nil then break end
    code = bit.bor(code, bit.lshift(num, i * 4))
  end
  return string.char(code)
end

local escape_map = {
  ["n"] = "\n",
  ["r"] = "\r",
  ["t"] = "\t",
  ["b"] = "\b",
  ["f"] = "\f",
  ["\\"] = "\\",
  ["\""] = "\"",
}

---@param scanner LinesScanner
---@return string
local function read_escape(scanner)
  local char = scanner:next()
  local mapped = escape_map[char]
  if mapped then
    return mapped
  elseif char ~= "u" then
    return char
  end

  return read_utf(scanner)
end

---@param lines string[]
---@param path string
function M.scan(lines, path)
  local keys = require("util.strings").split(path or "", "%.")
  local scanner = LinesScanner:new(lines)
  local stack = {}
  local quoted = false
  local in_key = true
  local key = ""
  local stack_strings = {}

  while true do
    local stack_modified = 0
    local char = scanner:next()

    if char == nil then
      break
    end

    if char == "\\" then
      local decoded = read_escape(scanner)
      if quoted and in_key then
        key = key .. decoded
      end
    elseif quoted then
      if char == '"' then
        quoted = false
      elseif in_key then
        key = key .. char
      end
    elseif char == "\"" then
      quoted = true
      if in_key then key = "" end
    elseif char == ":" then
      if #stack > 0 then
        stack[#stack] = key
        stack_strings[#stack_strings] = key
      else
        table.insert(stack, key)
        table.insert(stack_strings, key)
      end
      stack_modified = 1
      in_key = false
    elseif char == "{" then
      table.insert(stack, -1)
      table.insert(stack_strings, "")
      in_key = true
    elseif char == "[" then
      table.insert(stack, 0)
      table.insert(stack_strings, "0")
      stack_modified = 1
      in_key = false
    elseif char == "}" or char == "]" then
      table.remove(stack)
      table.remove(stack_strings)
      stack_modified = -1
    elseif char == "," then
      if #stack > 0 then
        if type(stack[#stack]) == "number" and stack[#stack] >= 0 then
          stack[#stack] = stack[#stack] + 1
          stack_strings[#stack_strings] = tostring(stack[#stack])
          stack_modified = 1
        else
          in_key = true
        end
      end
    end

    if stack_modified == 1 then
      if require "util.tables".is_equal(stack_strings, keys) then
        return scanner:pos()
      end
    end
  end

  return nil, nil
end

---@param buf number
---@param win number
---@param path string?
function M.goto_json(buf, win, path)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local function goto_path(p)
    local line, col = M.scan(lines, p)
    if line ~= nil and col ~= nil then
      vim.api.nvim_win_set_cursor(win, { line, col })
    else
      require("noice").notify('Key "' .. p ..'" not found', 'warn', {})
    end
  end

  if path == nil then
    vim.ui.input({ prompt = "JSON Path" }, function(p)
      if p == "" or p == nil then return end
      goto_path(p)
    end)
  else
    goto_path(path)
  end
end

return M
