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
---@return string
local function read_escape(scanner)

end

---@param lines string[]
---@param path string
function M.scan(lines, path)
  path = path or ""
  local keys = require("util.strings").split(path, ".")
  local scanner = LinesScanner:new(lines)
  local stack = {}
  local quoted = false
  local in_key = true
  local key = ""
  local stack_strings = {}

  while true do
    local stack_modified = 0
    local char = scanner:next()

    if char == nil then break end
    if char == "\\" then
      local decoded = read_escape(scanner)
      if quoted and in_key then
        key = key .. decoded
      elseif quoted then
        if char == "\"" then
          quoted = false
        elseif in_key then
          key = key .. char
        end
      end
    end
  end
end

return M
