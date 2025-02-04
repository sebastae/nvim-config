local M = {}

function M.init_snippets()
  require("luasnip.loaders.from_vscode").load({
    paths = { vim.fn.stdpath("config") .. "/snippets" }
  })

  local ls = require("luasnip")

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

    })
  })
end

return M
