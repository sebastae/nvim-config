local M = {}
local wk = require("which-key")
local tb = require("telescope.builtin")

local formatter = require("util.format")
local bufutil = require("util.buffer")

local gs = require("gitsigns")
local ccc = require("ccc")

local mc = require("multicursor-nvim")

---@param c string
---@return string
local function cmd(c)
  return "<cmd>" .. c .. "<cr>"
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
      { "<leader>n",        cmd("Neotree toggle"),                                                     silent = true,          desc = "Toggle NeoTree" },
      { "<C-n>",            cmd("Neotree toggle"),                                                     silent = true,          desc = "Toggle NeoTree" },
      { "<C-o>",            cmd("Outline"),                                                            silent = true,          desc = "Toggle outline" },


      -- Telescope
      { "<leader>f",        group = "file" },
      { "<leader>ff",       tb.find_files,                                                             desc = "Find files" },
      { "<leader><leader>", tb.find_files,                                                             desc = "Find files" },
      { "<leader>fg",       tb.live_grep,                                                              desc = "Live grep" },
      { "<leader>fb",       tb.buffers,                                                                desc = "Find buffer" },
      { "<leader>fh",       tb.help_tags,                                                              desc = "Help tags" },
      { "<leader>fG",       function() tb.find_files({ cwd = require("util.fs").get_git_root() }) end, desc = "Find git filed" },
      { "<leader>fm",       formatter.format,                                                          desc = "Format file" },
      {
        "<leader>fc",
        call_with_opts(tb.find_files, {
          cwd = vim.fn.stdpath("config")
        }),
        desc = "Find config files"
      },
      { "<leader>fp", tb.builtin,                                              desc = "Telescope builtins" },
      { "<leader>fo", function() require "config.telescope".find_object() end, desc = "Find objects" },

      -- Pickers
      { "<leader>pc", cmd(":CccPick"),                                         desc = "Pick color" },

      -- Files
      { "<leader>fn", cmd("enew"),                                             desc = "New File" },

      -- Groups
      { "<leader>c",  group = "Code actions" },
      { "<leader>b",  group = "Buffer" },

      -- Buffers
      { "<S-h>",      cmd("bprevious"),                                        desc = "Prev Buffer" },
      { "<S-l>",      cmd("bnext"),                                            desc = "Next Buffer" },
      { "[b",         cmd("bprevious"),                                        desc = "Prev Buffer" },
      { "]b",         cmd("bnext"),                                            desc = "Next Buffer" },
      { "<leader>bb", cmd("e #"),                                              desc = "Switch to Other Buffer" },
      { "<leader>`",  cmd("e #"),                                              desc = "Switch to Other Buffer" },
      { "<leader>bd", bufutil.bufremove,                                       desc = "Delete Buffer" },
      { "<leader>bD", cmd(":bd"),                                              desc = "Delete Buffer and Window" },
      { "<leader>bn", cmd("bn"),                                               desc = "Next buffer",             silent = true },
      { "<leader>bp", cmd("bp"),                                               desc = "Prev buffer",             silent = true },
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
      { "<leader>bA",      cmd("%bd"),                                    desc = "Close all buffers",  silent = true },
      { "<Tab>",           cmd("bn"),                                     desc = "Next buffer",        silent = true },
      { "<S-Tab>",         cmd("bp"),                                     desc = "Prev buffer",        silent = true },

      -- Better movement
      { "<C-h>",           "<C-w>h",                                      silent = true, },
      { "<C-j>",           "<C-w>j",                                      silent = true, },
      { "<C-k>",           "<C-w>k",                                      silent = true, },
      { "<C-l>",           "<C-w>l",                                      silent = true, },

      -- Gitsigns
      { "<leader>g",       group = "Git" },
      { "<leader>gh",      group = "hunks" },
      { "<leader>ghp",     gs.preview_hunk_inline,                        desc = "Preview Hunk Inline" },
      { "<leader>ghr",     gs.reset_hunk,                                 desc = "Reset Hunk" },
      { "<leader>ghb",     function() gs.blame_line({ full = true }) end, desc = "Blame line" },
      { "<leader>ghd",     gs.diffthis,                                   desc = "Diff this" },
      { "<leader>ghD",     function() gs.diffthis("~") end,               desc = "Diff this ~" },
      { "<leader>ghs",     gs.stage_hunk,                                 desc = "Stage hunk" },

      { "<leader>gb",      group = "buffer" },
      { "<leader>gbr",     gs.reset_buffer,                               desc = "Reset buffer" },
      { "<leader>gbs",     gs.stage_buffer,                               desc = "Stage buffer" },

      { "<leader>gt",      group = "toggle" },
      { "<leader>gtb",     gs.toggle_current_line_blame,                  desc = "Toggle blame" },
      { "<leader>gtw",     gs.toggle_word_diff,                           desc = "Toggle word diff" },

      -- Diagnostics, rest is added by autocommand in config/autocommands.lua
      { "<leader>x",       group = "Diagnostics" },
      { "<leader>xa",      cmd("Telescope diagnostics"),                  desc = "List diagnostics" },
      { "M",               function() vim.diagnostic.open_float() end,    desc = "Show diagnostics" },

      -- Scrollbind
      { "<F5>",            cmd("windo set scrollbind!"),                  desc = "Toggle scrollbind" },

      -- Copilot
      { "<leader>cc",      cmd("Copilot toggle"),                         desc = "Copilot toggle" },
      { "<leader>D",       cmd("Noice dismiss"),                          desc = "Dismiss messages" },
      -- Multicursors
      { "<C-leftmouse>",   mc.handleMouse,                                desc = "Add / remove cursor" },
      { "<C-leftdrag",     mc.handleMouseDrag,                            desc = "Add cursors" },
      { "<C-leftrelease>", mc.handleMouseRelease,                         desc = "Add cursors" },

      { "<leader>mr",      mc.restoreCursors,                             desc = "Restore cursors" },

      -- LSP
      { "<F3>",            cmd("LspRestart"),                             desc = "Restart LSP" },

    },
    {
      mode = { "v" },
      {
        -- Search
        { "/", function()
          local tmp = vim.fn.getreg('"')
          local input = vim.api.nvim_replace_termcodes([[y/<C-r>"]], true, false, true)
          vim.api.nvim_feedkeys(input, 'n', false)
          vim.fn.setreg('"', tmp)
        end },
      }
    },
    {
      mode = { "n", "x" },
      -- Add / skip cursors
      { "<leader>m",  group = "multicursors" },
      { "<C-up>",     function() mc.lineAddCursor(-1) end,   desc = "Add cursor above" },
      { "<C-down>",   function() mc.lineAddCursor(1) end,    desc = "Add cursor below" },
      { "<M-up>",     function() mc.lineSkipCursor(-1) end,  desc = "Skip cursor above" },
      { "<M-down>",   function() mc.lineSkipCursor(1) end,   desc = "Skip cursor below" },

      -- Add or skip lines by matching words / selection
      { "<leader>mn", function() mc.matchAddCursor(1) end,   desc = "Add matching cursor" },
      { "<leader>ms", function() mc.matchSkipCursor(1) end,  desc = "Skip matching cursor" },
      { "<leader>mN", function() mc.matchAddCursor(-1) end,  desc = "Add matching cursor" },
      { "<leader>mS", function() mc.matchSkipCursor(-1) end, desc = "Skip matching cursor" },

      { "<C-q>",      mc.toggleCursor,                       desc = "Toggle cursors" },
      { "<leader>mx", mc.clearCursors,                       desc = "Clear cursors" },

      { "ga",         mc.addCursorOperator,                  desc = "Add cursor with motion" },
      { "<leader>ma", mc.alignCursors,                       desc = "Align cursor columns" },
    },
    {
      mode = "x",
      { "<leader>mS", mc.splitCursors, desc = "Spliit visual selection by regex" },
      { "<leader>mM", mc.matchCursors, desc = "Match cursors within visual selection by regex" },
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
