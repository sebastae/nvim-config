local M = {}

function M.init()
  local mc = require("multicursor-nvim")
  mc.setup()

  -- Mappings
  mc.addKeymapLayer(function(set)
    set({ "n", "x" }, "<S-left>", mc.prevCursor, { desc = "Set previous cursor as main" })
    set({ "n", "x" }, "<S-right>", mc.nextCursor, { desc = "Set next cursor as main" })
    set({ "n", "x" }, "<C-x>", mc.deleteCursor, { desc = "Delete main cursor" })

    set("n", "<esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      else
        mc.clearCursors()
      end
    end)
  end)
end

return M
