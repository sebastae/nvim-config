local M = {}

M.spec = {
  { "hedyhli/outline.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      require "config.telescope".init()
    end
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      { "3rd/image.nvim", version = "v1.3.0" }
    },
    opts = {
      window = {
        position = "right"
      }
    },
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
  {
    "folke/snacks.nvim",
    init = function() require("config.snacks").init() end,
    priority = 1000
  },
  { "nvim-lualine/lualine.nvim",         opts = {} },
  { "lewis6991/gitsigns.nvim",           opts = {} },
  { "https://tpope.io/vim/fugitive.git", lazy = false },
  { "akinsho/bufferline.nvim",           opts = {} },
  { "stevearc/dressing.nvim",            opts = {} },

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
  { "uga-rosa/ccc.nvim" },

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
  { "jake-stewart/multicursor.nvim" },

  -- LSP
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim",           version = "*" },
      { "mason-org/mason-lspconfig.nvim", version = "*" },
      "yioneko/nvim-vtsls"
    },
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
  {
    "jmbuhr/otter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },

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
  {
    "natecraddock/workspaces.nvim",
    init = function()
      require "workspaces".setup()
      require "telescope".load_extension("workspaces")
      require "which-key".add({
        { "<leader>fw", "<cmd>Telescope workspaces<cr>", desc = "Find workspaces", silent = true, mode = { "n" } }
      })
    end
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
  require("config.completions").init()
  require("config.snippets").init_snippets()
  require("config.multicursor").init()
end

return M
