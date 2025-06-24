local M = {}

--- Check if the requested port is open by querying the system using ss
---@param port number
---@return boolean open the is port open
function M.is_port_open(port)
  local ok, result = pcall(function()
    return vim.fn.system({ "ss", "-lntpH", "sport = :" .. port })
  end)

  if not ok then
    print("Could not query ports: " .. result)
    return false
  end

  if result:len() > 0 then
    return true
  end
end

return M
