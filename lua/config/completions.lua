local M = {}

function M.init_cmp()
  local cmp = require("cmp")

  local function if_visible(f)
    local function inner(fallback)
      if cmp.visible() then
        f(fallback)
      else
        fallback()
      end
    end
    return inner
  end

  cmp.setup({
    snippet = {

      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered()
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      --['<C-d>'] = cmp.mapping.complete({ config = { sources = cmp.config.sources({ { name = 'copilot', group_index = 2 }, { name = "nvim_lsp", group_index = 2 } }) } }),
      ['<CR>'] = if_visible(cmp.mapping.confirm({ select = false })),
      ['<C-Tab>'] = cmp.mapping(function(fallback)
        local ls = require('luasnip')
        if ls.expand_or_locally_jumpable() then
          ls.expand_or_jump()
        else
          fallback()
        end
      end, {"i", "s"})
      --['<Tab>'] = if_visible(cmp.mapping.select_next_item()),
      --['<S-Tab>'] = if_visible(cmp.mapping.select_prev_item()),
    }),
    sources = cmp.config.sources(
      {
        { name = 'nvim_lsp', group_index = 2 },
        { name = 'path',     group_index = 2 },
        { name = 'luasnip',  group_index = 3 },
        -- { name = 'copilot',  group_index = 2 }
      },
      {
        { name = 'buffer' }
      }
    ),
    completion = {
      completeopt = 'menu,noselect',
    },
  })

  cmp.setup.cmdline({ '/', '?' }, {
    sources = cmp.config.sources({
      { name = 'cmdline' }
    })
  })
end

return M
