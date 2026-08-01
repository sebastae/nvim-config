---@type Module
return {
  plugins = {
    "https://github.com/rebelot/kanagawa.nvim"
  },
  init = function()
    vim.cmd.colorscheme("kanagawa-dragon")
  end
}
