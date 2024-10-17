local M = {}

local prettier_langs = {
  "css",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue"
}

local formatters = {
  lua = { "stylua" },
  sh = { "shfmt" },
}

function M.init_conform()
  local formatters_by_ft = {}

  for ft, cfg in ipairs(formatters) do
    formatters_by_ft[ft] = cfg
  end

  for _, ft in ipairs(prettier_langs) do
    formatters_by_ft[ft] = { "prettierd" }
  end


  require("conform").setup({
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = 'fallback'
    },
    formatters_by_ft = formatters_by_ft
  })
end

return M
