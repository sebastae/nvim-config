local M = {}

---@module 'lspconfig'
---@class ModuleLspConfig
---@field grammars? string[]
---@field servers? table<string, lspconfig.Config>
---@field modify_capabilities? table<string, fun(capabilities: lsp.ClientCapabilities)>
---@field additional_servers? string[]

---@class Module
---@field packages? LazySpec[]
---@field lspconfig? ModuleLspConfig
---@field init? function

---@type Module[]
local included_modules = {
  require("modules.core")
}

vim.list_extend(included_modules, require "modules.modules")
pcall(function() vim.list_extend(included_modules, require "modules.local") end)

function M.load_package_specs()
  local spec = {}
  for _, mod in ipairs(included_modules) do
    if mod.packages then
      vim.list_extend(spec, mod.packages)
    end
  end

  return spec
end

---@return string[]
function M.load_grammars()
  local grammars = {}
  for _, mod in ipairs(included_modules) do
    if mod.lspconfig then
      vim.list_extend(grammars, mod.lspconfig.grammars or {})
    end
  end
  return grammars
end

function M.load()
  -- Setup LSP
  ---@type ModuleLspConfig
  local lsp_configs = {}
  for _, mod in ipairs(included_modules) do
    if mod.lspconfig then
      require("util.core").merge(lsp_configs, mod.lspconfig)
    end
  end

  require("config.lsp").setup(lsp_configs)
  require("nvim-treesitter.configs").setup({
    ensure_installed = lsp_configs.grammars
  })


  for _, mod in ipairs(included_modules) do
    if mod.init then mod.init() end
  end
end

return M
