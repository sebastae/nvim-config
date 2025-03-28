local M = {}

function M.init()
  local t = require "telescope"

  t.setup({

  })
end

local object_types = {
  { "lua_files",  { search_file = "*.lua" } },
  { "components", { search_dirs = { "components" }, search_file = ".vue" } },
  { "atoms",      { search_dirs = { "components/atoms" }, search_file = ".vue" } },
  { "molecules",  { search_dirs = { "components/molecules" }, search_file = ".vue" } },
  { "organisms",  { search_dirs = { "components/organisms" }, search_file = ".vue" } },
}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local conf = require("telescope.config").values

function M.find_object(opts)
  opts = opts or {}

  if (opts.object_type and object_types[opts.object_type]) then
    require "telescope.builtin".find_files(object_types[opts.object_type])
    return
  end

  pickers.new({}, {
    finder = finders.new_table({
      results = object_types,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry[1],
          ordinal = entry[1]
        }
      end
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local entry = require "telescope.actions.state".get_selected_entry()
        require("telescope.builtin").find_files(entry.value[2])
      end)
      return true
    end
  }):find()
end

return M
