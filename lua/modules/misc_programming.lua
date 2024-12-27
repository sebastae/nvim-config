---@type Module
return {
  lspconfig = {
    grammars = {
      "rust"
    },
    servers = {
      ["rust_analyzer"] = {}
    }
  }
}
