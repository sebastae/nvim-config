-- Initialize core plugins and
---@type Module
local M = {
  plugins = {
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/MunifTanjim/nui.nvim",
    { src = "https://github.com/3rd/image.nvim", version = "v1.3.0" },
    "https://github.com/nvim-neo-tree/neo-tree.nvim",
    "https://github.com/hedyhli/outline.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-telescope/telescope-symbols.nvim",
    "https://github.com/folke/noice.nvim",
    "https://github.com/folke/trouble.nvim",
    "https://github.com/folke/snacks.nvim",
    "https://github.com/echasnovski/mini.nvim",
    "https://github.com/adelarsq/vim-matchit",
    "https://github.com/tpope/vim-repeat",
    "https://github.com/tpope/vim-surround",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/akinsho/bufferline.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
  },
  init = function()
    require 'config.neo-tree'
    require 'config.telescope'.init()
    require 'trouble'.setup()
    require 'config.mini'.setup()
    require 'config.snacks'.init()
    require 'noice'.setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        }
      },
      cmdline = { enabled = true },
      messages = { enabled = true },
    })

    require'which-key'.setup()
    vim.keymap.set("n", "<leader>?",
      function () require'which-key'.show({global = false}) end,
      {desc = "Buffer Local Keymaps (which-key)"}
    )

    require 'bufferline'.setup()
    require 'lualine'.setup()

    -- Set options
    require 'config.options'
    -- Load keybinds
    require 'config.keybinds.core'.init()

  end

}

return M
