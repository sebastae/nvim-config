local M = {}
local wk = require("which-key")
local tb = require("telescope.builtin")

local formatter = require("util.format")
local bufutil = require("util.buffer")

local gs = package.loaded.gitsigns

---@param c string
---@return string
local function cmd(c)
  return "<cmd>" .. c .. "<cr>"
end


---@param lhs string
---@return string
local function ld(lhs)
  return "<leader>" .. lhs
end

---@param lhs string
---@return string
local function gh(lhs)
  return ld("gh" .. lhs)
end

---@param fn function
---@param opts table
local function call_with_opts(fn, opts)
  return function()
    fn(opts)
  end
end

local function setup()
  wk.add({
    {
      mode = { "n" },
      -- NeoTree
      { "<leader>n",        cmd("Neotree toggle"), silent = true,       desc = "Toggle NeoTree" },
      { "<C-n>",            cmd("Neotree toggle"), silent = true,       desc = "Toggle NeoTree" },
      { "<C-o>",            cmd("Outline"),        silent = true,       desc = "Toggle outline" },


      -- Telescope
      { "<leader>f",        group = "file" },
      { "<leader>ff",       tb.find_files,         desc = "Find files" },
      { "<leader><leader>", tb.find_files,         desc = "Find files" },
      { "<leader>fg",       tb.live_grep,          desc = "Live grep" },
      { "<leader>fb",       tb.buffers,            desc = "Find buffer" },
      { "<leader>fh",       tb.help_tags,          desc = "Help tags" },
      { "<leader>fm",       formatter.format,      desc = "Format file" },
      {
        "<leader>fc",
        call_with_opts(tb.find_files, {
          cwd = vim.fn.stdpath("config")
        }),
        desc = "Find config files"
      },
      { "<leader>fp", tb.builtin,            desc = "Telescope builtins" },

      -- Files
      { "<leader>fn", cmd("enew"),           desc = "New File" },

      -- Groups
      { "<leader>c",  group = "Code actions" },
      { "<leader>b",  group = "Buffer" },

      -- Buffers
      { "<S-h>",      cmd("bprevious"),      desc = "Prev Buffer" },
      { "<S-l>",      cmd("bnext"),          desc = "Next Buffer" },
      { "[b",         cmd("bprevious"),      desc = "Prev Buffer" },
      { "]b",         cmd("bnext"),          desc = "Next Buffer" },
      { "<leader>bb", cmd("e #"),            desc = "Switch to Other Buffer" },
      { "<leader>`",  cmd("e #"),            desc = "Switch to Other Buffer" },
      { "<leader>bd", bufutil.bufremove,     desc = "Delete Buffer" },
      { "<leader>bD", cmd(":bd"),            desc = "Delete Buffer and Window" },
      { "<leader>bn", cmd("bn"),             desc = "Next buffer",             silent = true },
      { "<leader>bp", cmd("bp"),             desc = "Prev buffer",             silent = true },
      {
        "<leader>ba",
        function()
          local buf = vim.api.nvim_get_current_buf()
          local buffers = vim.api.nvim_list_bufs()
          for _, b in ipairs(buffers) do
            if b ~= buf then
              vim.api.nvim_buf_delete(b, { force = true })
            end
          end
        end,
        desc = "Close all other buffers",
        silent = true
      },
      { "<leader>bA", cmd("%bd"),                                    desc = "Close all buffers",  silent = true },
      { "<Tab>",      cmd("bn"),                                     desc = "Next buffer",        silent = true },
      { "<S-Tab>",    cmd("bp"),                                     desc = "Prev buffer",        silent = true },

      -- Better movement
      { "<C-h>",      "<C-w>h",                                      silent = true, },
      { "<C-j>",      "<C-w>j",                                      silent = true, },
      { "<C-k>",      "<C-w>k",                                      silent = true, },
      { "<C-l>",      "<C-w>l",                                      silent = true, },

      -- Gitsigns
      { ld("gh"),     group = "hunks" },
      { gh("p"),      gs.preview_hunk_inline,                        desc = "Preview Hunk Inline" },
      { gh("r"),      gs.reset_hunk,                                 desc = "Reset Hunk" },
      { gh("R"),      gs.reset_buffer,                               desc = "Reset buffer" },
      { gh("b"),      function() gs.blame_line({ full = true }) end, desc = "Blame line" },
      { gh("d"),      gs.diffthis,                                   desc = "Diff this" },
      { gh("D"),      function() gs.diffthis("~") end,               desc = "Diff this ~" },

      -- Diagnostics, rest is added by autocommand in config/autocommands.lua
      { "<leader>x",  group = "Diagnostics" },
      { "<leader>xa", cmd("Telescope diagnostics"),                  desc = "List diagnostics" },

      -- Scrollbind
      { "<F5>",       cmd("windo set scrollbind!"),                  desc = "Toggle scrollbind" },

      -- Copilot
      { "<leader>cc", cmd("Copilot toggle"),                         desc = "Copilot toggle" },
      { "<leader>d", cmd("Noice dismiss"), desc = "Dismiss messages" },
    },
    {
      mode = { "v" },
      {
        -- Search
        {"/", function()
          local tmp = vim.fn.getreg('"')
          local input = vim.api.nvim_replace_termcodes([[y/<C-r>"]], true, false, true)
          vim.api.nvim_feedkeys(input,  'n',  false)
          vim.fn.setreg('"', tmp)
        end },
      }
    }
  }
  )
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true

  setup()
end

return M
