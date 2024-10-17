local M = {}

function M.format()
	local buf = vim.api.nvim_get_current_buf()
	local success, status = pcall(function() return require("conform").format({ bufnr = buf }) end)
	return success
end

return M
