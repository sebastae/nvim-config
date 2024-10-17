local M = {}

M.ensure_installed = {

  -- Frontend development
  "html",
  "css",
  "javascript",
  "vue",
  "scss",
  "typescript",
  "json",
  "typescriptreact",
  "javascriptreact",
  "json",

  -- Backend development
  "go",
  "java",
  "sql",

  -- Other
  "lua",
  "sh",
}

local servers = {
  ["lua_ls"] = {},
  ["typos_lsp"] = {},
  ["eslint"] = {
    ---@param client vim.lsp.Client
    ---@param buf number
    on_attach = function(client, buf)
      vim.keymap.set("n", "<leader>ce", "<cmd>EslintFixAll<cr>", { buffer = buf, desc = "ESLint fix all" })
    end
  },
  ["jsonls"] = {},
  ["cssls"] = {},
  ["gopls"] = {},
  ["somesass_ls"] = {}
}

local modify_capabilities = {
  ["cssls"] = function(capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = true
  end
}

local additional_servers = {
  "vtsls",
  "volar",
  "ts_ls",
  "jdtls"
}

function M.setup()
  -- Ensure servers are installed by Mason
  local servernames = vim.list_extend(vim.tbl_keys(servers), additional_servers)

  require("mason-lspconfig").setup({
    ensure_installed = servernames
  })

  -- Configure servers
  for name, config in pairs(servers) do
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local common_config = {
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    }

    if modify_capabilities[name] then
      modify_capabilities[name](capabilities)
    end

    require("util.core").merge(config, common_config)
    require("lspconfig")[name].setup(config)
  end



  require("config.typescript")
end

return M
