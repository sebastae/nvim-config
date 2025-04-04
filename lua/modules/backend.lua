---@type Module
return {
  packages = {
    { "mfussenegger/nvim-jdtls" },
    { "mfussenegger/nvim-dap",  init = require "config.debug".init_dap },
    { "leoluz/nvim-dap-go",     ft = "go",                                  init = require "config.debug".init_go },
    { "rcarriga/nvim-dap-ui",   dependencies = { "nvim-neotest/nvim-nio" }, init = require "config.debug".init_ui },
  },
  lspconfig = {
    servers = {
      ["gopls"] = {},
      ["sqls"] = {}
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
