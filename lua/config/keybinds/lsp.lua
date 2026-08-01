local M = {}

local wk = require'which-key'
local formatter = require("util.format")

local is_loaded = false
function M.load()
  if is_loaded then return end

  wk.add({
    mode = {"n"},
    {"<leader>fm", formatter.format}
  })

  is_loaded = true
end

return M
