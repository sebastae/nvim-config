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
  { "hedyhli/outline.nvim" },
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
      messages = { enabled = true },
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
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip"
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
  { "echasnovski/mini.nvim" },

  -- LSP
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "yioneko/nvim-vtsls" },
    version = '*'
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
  { "zbirenbaum/copilot.lua",   cmd = "Copilot", event = "InsertEnter", config = function() require("config.copilot") end },
  { "zbirenbaum/copilot-cmp",   lazy = true,     opts = {} },

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
  require "telescope".setup {}
  require "outline".setup {}

  require("config.neo-tree")
  require('config.mini').setup()
  require("config.formatting").init_conform()
  require("config.completions").init_cmp()
  require("config.snippets").init_snippets()
end

return M
