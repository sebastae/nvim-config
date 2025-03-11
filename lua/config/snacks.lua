local M = {}

function M.init()
  local s = require "snacks"

  s.setup({
    bigfile = { enabled = true },
    dim = { enabled = true },
    zen = { enabled = true, }
  })

  local wk = require("which-key")
  wk.add({
    { "<leader>s",  group = "snacks" },
    { "<leader>sz", s.zen.zen,       desc = "Toggle zen mode" },
    { "<leader>sd",
      function()
        if s.dim.enabled then
          s.dim.disable()
        else
          s.dim.enable()
        end
      end, desc = "Toggle dim" }
  })
end

return M
