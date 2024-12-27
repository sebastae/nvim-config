---@type Module
local M = {
  lspconfig = {
    servers = {
      ["eslint"] = {
        ---@param client vim.lsp.Client
        ---@param buf number
        on_attach = function(client, buf)
          vim.keymap.set("n", "<leader>ce", "<cmd>EslintFixAll<cr>", { buffer = buf, desc = "ESLint fix all" })
        end
      },
      ["cssls"] = {},
      ["somesass_ls"] = {},
    },
    grammars = {
      "html",
      "css",
      "javascript",
      "vue",
      "scss",
      "typescript",
      "json",
    },
    additional_servers = {
      "vtsls",
      "volar",
      "ts_ls",
    },
    modify_capabilities = {
      ["cssls"] = function(capabilities)
        capabilities.textDocument.completion.completionItem.snippetSupport = true
      end
    }
  },
  init = function()
    require("config.typescript")
  end
}
return M
