require("lspconfig.configs").vtsls = require("vtsls").lspconfig

local fts = require("lspconfig.configs.vtsls").default_config.filetypes
table.insert(fts, "vue")

local lsp = require("util.lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()

require("lspconfig").vtsls.setup({
  filetypes = fts,
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      }
    },
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = require("util.lsp").get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true
          }
        }
      }
    }
  },
  on_attach = function(client, buf)
    vim.keymap.set("n",
      "gd",
      function()
        local params = vim.lsp.util.make_position_params()
        lsp.execute({
          command = "typescript.goToSourceDefinition",
          arguments = { params.textDocument.uri, params.position },
          open = true
        })
      end,
      {
        desc = "goto source definition",
        buffer = buf
      })

    vim.keymap.set("n",
      "gr",
      function()
        lsp.execute({
          command = "typescript.findAllFileReferences",
          arguments = { vim.uri_from_bufnr(0) },
          open = true
        })
      end,
      { desc = "file references", buffer = buf }
    )

    vim.keymap.set("n", "<leader>co", lsp.make_action("source.organizeImports"),
      { desc = "organize imports", buffer = buf })
    vim.keymap.set("n", "<leader>cm", lsp.make_action("source.addMissingImports.ts"),
      { desc = "add missing imports", buffer = buf })
    vim.keymap.set("n", "<leader>cu", lsp.make_action("source.removeUnused.ts"),
      { desc = "remove unused imports", buffer = buf })
    vim.keymap.set("n", "<leader>cd", lsp.make_action("source.fixAll.ts"), { desc = "fix all diagnostics", buffer = buf })
    vim.keymap.set(
      "n",
      "<leader>cv",
      lsp.make_execute({ command = "typescript.selectTypeScriptVersion" }),
      { desc = "select ts workspace version", buffer = buf }
    )


    client.commands["_typescript.moveToFileRefactoring"] = function(command)
      ---@type string, string, lsp.Range
      local action, uri, range = unpack(command.arguments)

      local function move(newf)
        client.request("workspace/executeCommand", {
          command = command.command,
          arguments = { action, uri, range, newf }
        })
      end

      local fname = vim.uri_to_fname(uri)
      client.request("workspace/executeCommand", {
        command = "typescript.tsserverRequest",
        arguments = {
          "getMoveToRefactoringFileSuggestions",
          {
            file = fname,
            startLine = range.start.line + 1,
            startOffset = range.start.character + 1,
            endLine = range["end"].line + 1,
            endOffset = range["end"].character + 1
          }
        }
      }, function(_, result)
        ---@type string[]
        local files = result.body.files
        table.insert(files, 1, "Enter new path...")
        vim.ui.select(files, {
          prompt = "Select move destination:",
          format_item = function(f)
            return vim.fn.fnamemodify(f ":~:.")
          end
        }, function(f)
          if f and f:find("^Enter new path") then
            vim.ui.input({
              prompt = "Enter move destination:",
              default = vim.fn.fnamemodify(fname, ":h") .. "/",
              completion = "file"
            }, function(newf)
              return newf and move(newf)
            end)
          elseif f then
            move(f)
          end
        end)
      end)
    end
  end



})

require("lspconfig").volar.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
  init_options = {
    vue = {
      hybridMode = true
    }
  }
})
