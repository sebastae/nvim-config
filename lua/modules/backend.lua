---@type Module
return {
  packages = {
    { "mfussenegger/nvim-jdtls" },
  },
  lspconfig = {
    servers = {
      ["gopls"] = {},
    },
    additional_servers = {
      "jdtls"
    },
    grammars = {
      "go",
      "java",
      "sql"
    },
  }
}
