local M = {}

---@param s string
---@param sep string
---@return string[]
function M.split(s, sep)
  local parts = {}
  if sep == nil then sep = "%s" end
  for str in string.gmatch(s, "[^"..sep.."]+") do
    table.insert(parts, str)
  end
  return parts
end

return M
