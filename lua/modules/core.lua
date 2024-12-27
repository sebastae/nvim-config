---@type Module
local M = {
  packages = require("config.plugins").spec,
  init = function()
    require("config.plugins").init()
    require("config.keymaps").init()
    require("config.autocommands")
    require("config.options")
    require("config.commands")
  end,
  lspconfig = {
    servers = {
      ["lua_ls"] = {},
      ["typos_lsp"] = {},
      ["jsonls"] = {},
    },
    grammars = {
      "lua",
    }
  }
}

return M
