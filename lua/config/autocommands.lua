---@param c string
---@return string
local function cmd(c)
  return "<cmd>" .. c .. "<cr>"
end

---@type {[string]: {[1]: string|string[], [2]: string|fun(), [3]: string}[]}
local keymaps = {
  ["textDocument/declaration"] = {
    { "gD", vim.lsp.buf.declaration, "Go to declaration" },
  },
  ["textDocument/definition"] = {
    { "gd", cmd("Telescope lsp_definitions"), "Show definitions" },
  },
  ["textDocument/implementation"] = { { "gi", vim.lsp.buf.implementation, "Go to implementation" } },
  ["textDocument/references"] = { { "gr", cmd("Telescope lsp_references"), "Show references" } },
  ["textDocument/rename"] = { { "<F2>", vim.lsp.buf.rename, "Rename symbol" } },
  ["textDocument/codeAction"] = { { "<leader>ca", vim.lsp.buf.code_action, "Code Action" } },
  ["textDocument/signatureHelp"] = { { "S", vim.lsp.buf.signature_help, "Signature help" } },
  ["textDocument/documentHighlight"] = { { "<leader>hh", vim.lsp.buf.document_highlight, "Document highlight" } },
  ["textDocument/documentSymbol"] = { { "<C-s>", vim.lsp.buf.document_symbol, "Document symbols" } },
  ["textDocument/diagnostic"] = {
    { "<leader>xx",  vim.diagnostic.open_float,                                                             "Line diagnostics" },
    { "<leader>xn",  vim.diagnostic.goto_next,                                                              "Go to next" },
    { "<leader>xp",  vim.diagnostic.goto_prev,                                                              "Go to prev" },
    { "<leader>xen", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, "Go to next error" },
    { "<leader>xep", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, "Go to prev error" },
    { "<leader>xwn", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end,  "Go to next warning" },
    { "<leader>xwp", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end,  "Go to prev warning" },
  },
}



-- Add keymaps for code actions
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buf = args.buf

    if not client then return end
    for method, keys in pairs(keymaps) do
      if client.supports_method(method) then
        for _, spec in ipairs(keys) do
          local lhs, command, desc = unpack(spec)
          for _, key_cmb in ipairs((type(lhs) == "table") and lhs or { lhs }) do
            vim.keymap.set("n", key_cmb, command, { desc = desc, buffer = buf })
          end
        end
      end
    end
  end
})

local json_path_gr = vim.api.nvim_create_augroup("json_path", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "CursorMoved" }, {
  pattern = "*.json",
  group = json_path_gr,
  callback = require("util.json").show_json_path
})

vim.api.nvim_create_autocmd({ "BufAdd" }, {
  pattern = "*.json",
  group = json_path_gr,
  callback = function(opts)
    vim.keymap.set("n", "<C-j>", function()
        local win = vim.api.nvim_get_current_win()
        require "util.json".goto_json(opts.buf, win)
      end,
      { buffer = opts.buf })
  end
})

-- Start jdtls on entering java buffer
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = "*.java",
  callback = require("config.jdtls").start
})

-- Rulers
local crosshair_gr = vim.api.nvim_create_augroup('crosshairs', { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "WinNew", "VimEnter", "BufEnter" }, {
  group = crosshair_gr,
  callback = function(opts)
    local readonly = vim.api.nvim_get_option_value('readonly', { buf = opts.buf })
    vim.api.nvim_set_option_value('cursorline', not readonly, { win = opts.win })
    vim.api.nvim_set_option_value('cursorcolumn', not readonly, { win = opts.win })
  end
})

vim.api.nvim_create_autocmd({ "OptionSet" }, {
  group = crosshair_gr,
  pattern = "readonly",
  callback = function(opts)
    local readonly = vim.api.nvim_get_option_value('readonly', { buf = opts.buf })

    vim.api.nvim_set_option_value('cursorline', not readonly, { win = opts.win })
    vim.api.nvim_set_option_value('cursorcolumn', not readonly, { win = opts.win })
  end
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = crosshair_gr,
  callback = function(opts)
    vim.api.nvim_set_option_value('cursorline', false, { win = opts.win })
    vim.api.nvim_set_option_value('cursorcolumn', false, { win = opts.win })
  end
})


local highlight_gr = vim.api.nvim_create_augroup("document_highlight", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  callback = function(opts)
    local client = vim.lsp.get_client_by_id(opts.data.client_id)

    if client and client.supports_method('textDocument/documentHighlight') then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = opts.buf,
        group=highlight_gr,
        callback = vim.lsp.buf.document_highlight
      })

      vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        buffer = opts.buf,
        group=highlight_gr,
        callback = vim.lsp.buf.clear_references
      })
    end
  end
})

vim.api.nvim_create_autocmd({"LspDetach"}, {
  callback = function(opts)
    local client = vim.lsp.get_client_by_id(opts.data.client_id)
    if client and client.supports_method('textDocument/documentHighlight') then
      vim.api.nvim_clear_autocmds({group = highlight_gr})
    end
  end
})
