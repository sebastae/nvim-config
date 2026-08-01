---@type Module
local M = {
  plugins = {
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/hrsh7th/nvim-cmp",
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/folke/lazydev.nvim"
  },
  init = function()
    local server_configs = {
      require "modules.lsp-configs.basic"
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local common_config = {}


    local ok, cmp_capabilities = pcall(function()
      return require 'cmp_nvim_lsp'.default_capabilities(capabilities)
    end)
    if ok then
      common_config["capabilities"] = cmp_capabilities
    end

    -- Mason setup
    local server_names = {}
    for _, config in ipairs(server_configs) do
      vim.list_extend(server_names, vim.tbl_keys(config.servers))
    end

    require "mason".setup()

    local ok, result = pcall(require "mason-lspconfig".setup, {
      ensure_installed = server_names,
      automatic_enable = true
    })
    if not ok then
      vim.notify("Error during mason setup: " .. result)
    end

    for _, config in ipairs(server_configs) do
      if config.servers then
        for name, opts in pairs(config.servers) do
          require "util.core".merge(opts, common_config)

          if config.modify_capabilities and config.modify_capabilities[name] then
            local ok, result = pcall(function() config.modify_capabilities[name](capabilities) end)
            if not ok then
              local message = 'Could not modify capabilities for lspconfig "' .. name .. '": ' .. result
              vim.notify(message, vim.log.levels.ERROR)
            end
          end

          local ok, result = pcall(function()
            vim.lsp.config(name, config)
          end)
          if not ok then
            local message = 'Could not run setup for lspconfig "' .. name .. '": ' .. result
            vim.notify(message, vim.log.levels.ERROR)
          end
        end
      end
    end

    require 'lazydev'.setup()

    require 'config.formatting'.init_conform()
    require 'cmp'.setup({})
    require 'config.keybinds.lsp'.load()
  end
}

return M
