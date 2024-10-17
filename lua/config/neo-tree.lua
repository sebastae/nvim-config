local nt = require("neo-tree")

nt.setup({
  filesystem = {
    follow_current_file = {enabled = true}
  },
  window = {
    position = "right",
    mappings = {
      ["P"] = {"toggle_preview", config = {use_float = true}}
    }
  },
})
