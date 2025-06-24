local M = {}
---@param configs ModuleLspConfig
function M.setup(configs)
  -- Ensure servers are installed by Mason
  ---@type string[]
  local ensure_installed = {}
  vim.list_extend(ensure_installed, vim.tbl_keys(configs.servers or {}))
  vim.list_extend(ensure_installed, configs.additional_servers or {})
  require("mason-lspconfig").setup({
    ensure_installed = ensure_installed,
    automatic_enable = false
  })

  -- Configure servers
  for name, config in pairs(configs.servers) do
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local common_config = {
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    }

    if configs.modify_capabilities[name] then
      configs.modify_capabilities[name](capabilities)
    end

    require("util.core").merge(config, common_config)
    require("lspconfig")[name].setup(config)
  end
end

return M
