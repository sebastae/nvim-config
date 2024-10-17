local util = require('util.nvim')

vim.api.nvim_create_user_command('StringifyList', function(opts)
  local str = util.get_visual_selection() or ''
  local items = vim.split(str, ',')

  for i, item in ipairs(items) do
    items[i] = string.format("'%s'", item:gsub("^%s*(.-)%s*$", "%1"))
  end

  local buf, s_row, s_col = unpack(vim.fn.getpos("'<"))
  local _, e_row, e_col = unpack(vim.fn.getpos("'>"))

  vim.api.nvim_buf_set_text(buf, s_row - 1, s_col - 1, e_row - 1, e_col, { table.concat(items, ', ') })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', false)
end, { range = true })


vim.api.nvim_create_user_command("GotoJson", function(opts)
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  if opts.nargs == 0 then
    require "notify".notify('Please provide a key to search', "info")
    return
  end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local line, col = require "util.json".scan(lines, opts.args)
  if line ~= nil and col ~= nil then
    vim.api.nvim_win_set_cursor(win, { line, col })
  else
    require "notify".notify('Key "' .. opts.args .. '" not found', "warn")
  end
end, { nargs = 1 })
