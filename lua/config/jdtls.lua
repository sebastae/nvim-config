local M = {}

function M.start()
  local jdtls_loc = require"util.lsp".get_pkg_path("jdtls", "bin/jdtls")


  require("jdtls").start_or_attach({
    cmd = { jdtls_loc },
    root_dir = vim.fs.dirname(vim.fs.find({ 'pom.xml', '.git' }, { upward = true })[1]),
    settings = {
      java = {
        configuration = {
          runtimes = {
            { name = "JavaSE-1.8", path = "/usr/lib/jvm/java-8-openjdk-amd64/" },
            { name = "JavaSE-11",  path = "/usr/lib/jvm/java-11-openjdk-amd64/" },
            { name = "JavaSE-23",  path = "/usr/lib/jvm/java-23-openjdk-amd64/" },
          }
        }
      }
    }
  })

  local wk = require("which-key")
  local buf = vim.api.nvim_get_current_buf()
  wk.add({
    buffer = buf,
    {
      { "<leader>cr",  group = "Extract" },
      { "<leader>co",  function() require "jdtls".organize_imports() end,                desc = "Organize imports" },
      { "<leader>crv", function() require "jdtls".extract_variable() end,                desc = "Extract variable" },
      { "<leader>crv", function() require "jdtls".extract_variable({ visual = true }) end, desc = "Extract variable", mode = "v" },
      { "<leader>crc", function() require "jdtls".extract_constant() end,                desc = "Extract constant" },
      { "<leader>crc", function() require "jdtls".extract_constant({ visual = true }) end, desc = "Extract constant", mode = "v" },
      { "<leader>crm", function() require "jdtls".extract_method() end,                  desc = "Extract method" }

    },
  })
end

return M
