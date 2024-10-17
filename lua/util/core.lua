local M = {}

function M.merge(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" and type(t1[k] or false) == "table" then
      M.merge(t1[k], v)
    elseif (t1[k] == nil) then
      t1[k] = v
    end
  end
  return t1
end

---@generic T
---@param t T[]
---@param key string
---@param values T[]
---@return T[]?
function M.extend(t, key, values)
  local keys = vim.split(key, ".", { plain = true })
  for i = 1, #keys do
    local k = keys[i]
    t[k] = t[k] or {}
    if type(t) ~= "table" then
      return
    end
    t = t[k]
  end
  return vim.list_extend(t, values)
end

return M
