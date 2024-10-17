local M = {}

function M.bufremove()
	local buf = vim.api.nvim_get_current_buf()
	if vim.bo.modified then
		local should_write = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "%Yes\n&No\n&Cancel")
		if should_write == 0 or should_write == 3 then
			return
		end
		if should_write == 1 then
			vim.cmd.write()
		end
	end

	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.api.nvim_win_call(win, function()
			if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
				return
			end

			local alt = vim.fn.bufnr("#")
			if alt ~= buf and vim.fn.buflisted(alt) == 1 then
				vim.api.nvim_win_set_buf(win, alt)
				return
			end

			local has_prev = pcall(vim.cmd, "bprevious")
			if has_prev and buf ~= vim.api.nvim_win_get_buf(win) then
				return
			end

			local new_buf = vim.api.nvim_create_buf(true, false)
			vim.api.nvim_win_set_buf(win, new_buf)
		end)
	end

	if vim.api.nvim_buf_is_valid(buf) then
		pcall(vim.cmd, "bdelete! " .. buf)
	end
end

return M
