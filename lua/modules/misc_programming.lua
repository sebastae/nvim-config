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
      ["rust_analyzer"] = {}
    }
  }
}
