local M = {}

M.spec = {
  {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = true,
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim"
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "3rd/image.nvim"
    },
    opts = {
      window = {
        position = "right"
      }
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  { "williamboman/mason.nvim",  opts = {} },
  { "folke/todo-comments.nvim", opts = {} },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify"
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        }
      },
      cmdline = { enabled = true },
      messages = { enabled = false },
    },
  },
  { "folke/trouble.nvim" },
  { "nvim-lualine/lualine.nvim", opts = {} },
  { "lewis6991/gitsigns.nvim",   opts = {} },
  { "akinsho/bufferline.nvim",   opts = {} },
  { "stevearc/dressing.nvim",    opts = {} },

  -- Formatting
  { "stevearc/conform.nvim" },
  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "stevearc/conform.nvim",
      "williamboman/mason.nvim",
    },
    opts = {},
  },

  -- Completions
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip"
    },
  },

  -- Motions
  {
    "tpope/vim-surround",
    dependencies = {
      { "adelarsq/vim-matchit" },
      { "tpope/vim-repeat" }
    },
    event = "VeryLazy"
  },
  {
    "echasnovski/mini.ai",
    opts = function()
      return {
        custom_textobjects = {
          v = require("mini.ai").gen_spec.pair(":", ","),
        }
      }
    end
  },

  -- LSP
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = { ensure_installed = require("config.lsp").ensure_installed }
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "yioneko/nvim-vtsls" }
  },
  {
    "folke/lazydev.nvim",
    lazy = true,
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
      }
    }
  },
  { "phelipetls/jsonpath.nvim", },
  { "Procrat/oz.vim",           ft = "oz" },
  { "mfussenegger/nvim-jdtls" },
  { "imsnif/kdl.vim",           ft = "kdl" },
  { "zbirenbaum/copilot.lua",   cmd = "Copilot", event = "InsertEnter", config = function() require("config.copilot") end },
  { "zbirenbaum/copilot-cmp",   lazy = true, opts = {} },

  -- Keybinds
  {
    "folke/which-key.nvim",
    dependencies = { "echasnovski/mini.icons" },
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require "which-key".show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)"
      }
    }
  },

  -- Color themes
  { "rebelot/kanagawa.nvim" },
  { "conweller/muted.vim" },
}

function M.init()
  require("config.neo-tree")
  require("config.telescope")
  require("config.formatting").init_conform()
  require("config.completions").init_cmp()
  require("config.lsp").setup()
  require("config.snippets").init_snippets()
end

return M
