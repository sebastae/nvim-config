
---@alias PluginSpec (string|vim.pack.Spec)

---@class Module
---@field plugins? PluginSpec[]
---@field lspconfig? ModuleLspConfig
---@field init? function

---@module 'lspconfig'
---@class ModuleLspConfig
---@field grammars? string[]
---@field servers? table<string, lspconfig.Config>
---@field modify_capabilities? table<string, fun(capabilities: lsp.ClientCapabilities)>
---@field additional_servers? string[]

---@type Module[]
local loaded_modules = {
  require "modules.core",
  require "modules.theme",
  require "modules.lsp",
}

pcall(function ()
  vim.list_extend(loaded_modules, require "modules.local")
end)

---@param modules Module[]
---@return PluginSpec[]
local function load_plugin_specs(modules)
  local all_specs = {}
  for _, mod in ipairs(modules) do
    if mod.plugins then
      vim.list_extend(all_specs, mod.plugins)
    end
  end

  return all_specs
end

pcall(function() vim.pack.add(load_plugin_specs(loaded_modules)) end)

for _, mod in ipairs(loaded_modules) do
  if mod.init then
    local ok, err = pcall(mod.init)
    if not ok then
      vim.notify("Error on module init" .. err, vim.log.levels.ERROR)
    end
  end
end



