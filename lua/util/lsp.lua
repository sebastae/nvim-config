local M = {}

---@class LspCommand: lsp.ExecuteCommandParams
---@field open? boolean
---@field handler? lsp.Handler

---@param opts LspCommand
function M.execute(opts)
  local params = {
    command = opts.command,
    arguments = opts.arguments
  }

  if opts.open then
    require("trouble").open({
      mode = "lsp_command",
      params = params,
    })
  else
    return vim.lsp.buf_request(0, "workspace/executeCommand", params, opts.handler)
  end
end

---@param on_attach fun(client:vim.lsp.Client, buffer)
---@param name? string
function M.on_attach(on_attach, name)
  return vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and (not name or client.name == name) then
        return on_attach(client, buffer)
      end
    end
  })
end

---@param pkg string
---@param path? string
function M.get_pkg_path(pkg, path)
  pcall(require, "mason")
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if not vim.loop.fs_stat(ret) then
    require("lazy.core.util").warn(("Mason package path not found for **%s**:\n- `%s`"):format(pkg, path))
  end
  return ret
end

---@param action string
function M.make_action(action)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = {
        only = { action },
        diagnostics = {}
      }
    })
  end
end

function M.make_execute(opts)
  return function()
    M.execute(opts)
  end
end

return M
