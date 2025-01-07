local M = {}

local uv = vim.uv or vim.loop

function M.get_git_root()

  local dir = uv.cwd()
  local success, result = pcall(function() return vim.fn.system({'git', 'rev-parse', '--show-toplevel'}) end)

  if success then 
    dir = string.gsub(result, '\n', '')
  end

  return dir
end

return M
