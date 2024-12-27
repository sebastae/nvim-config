local M = {}

function M.setup()
  local miniai = require("mini.ai")

  miniai.setup({
    custom_textobjects = {
      v = miniai.gen_spec.pair(":", ","),
      V = miniai.gen_spec.pair(":", "}")
    }
  })

  require "mini.splitjoin".setup()
  require "mini.surround".setup()
end

return M
