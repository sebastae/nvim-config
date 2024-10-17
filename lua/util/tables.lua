local M = {}

---@param a table
---@param b table
---@return boolean
function M.is_equal(a, b)
  if type(a) ~= type(b) then return false end
  if type(a) ~= 'table' then return a == b end
  for k, v in pairs(a) do
    if not M.is_equal(v, b[k]) then return false end
  end
  for k, v in pairs(b) do
    if not M.is_equal(v, a[k]) then return false end
  end
  return true
end

return M
