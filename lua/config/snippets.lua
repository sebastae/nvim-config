local M = {}

function M.init_snippets()

  local ls = require("luasnip")

  ls.config.set_config({
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave'
  })

  require("luasnip.loaders.from_vscode").load({
    paths = { vim.fn.stdpath("config") .. "/snippets" }
  })


  ls.add_snippets("vue", {
    ls.snippet("vbase3ts", {
      ls.text_node({
        "<template>",
        "\t<div></div>",
        "</template>",
        "<script lang=\"ts\">",
        "export default defineComponent({",
        "\tsetup(){"
      }),
      ls.insert_node(0),
      ls.text_node({
        "",
        "\t}",
        "})",
        "</script>",
      }),

    }),
    ls.snippet("vbase3tssetup", {
      ls.text_node({
        "<template>",
        "\t<div></div>",
        "</template>",
        "<script setup lang=\"ts\">",
        ""
      }),
      ls.insert_node(0),
      ls.text_node({ "", "</script>" })
    })
  })
end

return M
