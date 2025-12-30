---@type Module
return {
  packages = {
    { "Procrat/oz.vim", ft = "oz" },
    { "imsnif/kdl.vim", ft = "kdl" },
  },
  lspconfig = {
    grammars = {
      "rust"
    },
    servers = {
      ["rust_analyzer"] = {},
      ["pylsp"] = {},
      ["bashls"] = {},
    }
  },
  init = function()
    local mr = require "mason-registry"
    if not mr.is_installed("shfmt") then
      vim.cmd("MasonInstall shfmt")
    end
  end
}
