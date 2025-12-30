---@type Module
local M = {
  packages = require("config.plugins").spec,
  init = function()
    require("config.plugins").init()
    require("config.keymaps").init()
    require("config.autocommands")
    require("config.options")
    require("config.commands")

    vim.cmd("TSEnable highlight")
    vim.cmd("TSEnable incremental_selection")
    -- vim.cmd("TSEnable indent")
  end,
  lspconfig = {
    servers = {
      ["lua_ls"] = {},
      ["typos_lsp"] = {
        init_options = {
          diagnosticSeverity = "Warning"
        }
      },
      ["jsonls"] = {},
    },
    grammars = {
      "lua",
    }
  }
}

return M
