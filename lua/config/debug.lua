local M = {}

function M.init_ui()
  local dui = require("dapui")

  dui.setup()
  require("which-key").add({
    { "<leader>dt", dui.toggle, desc = "Toggle DAP UI", mode = 'n', silent = true },
  })

  local dap = require("dap")
  dap.listeners.before.attach.dapui_config = function()
    dui.open()
  end

  dap.listeners.before.event_terminated.dapui_config = function()
    dui.close()
  end

  dap.listeners.before.event_exited.dapui_config = function()
    dui.close()
  end
end

function M.init_dap()
  local dap     = require("dap")
  local widgets = require("dap.ui.widgets")
  local wk      = require("which-key")

  wk.add({
    mode = 'n',
    { "<leader>d",  group = "debug", },
    { "<leader>dc", function() dap.continue() end,                                                    desc = "Continue debug", },
    { "<leader>dP", function() dap.pause() end },
    { "<leader>db", function() dap.toggle_breakpoint() end,                                           desc = "Toggle breakpoint", },
    { "<leader>dB", function() dap.set_breakpoint() end,                                              desc = "Set breakpoint" },
    { "<leader>dC", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,        desc = "Set conditional breakpoint" },
    { "<leader>dl", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "Set log point" },
    { "<leader>df", function() widgets.centered_float(widgets.frames) end,                            desc = "Show frames" },
    { "<leader>ds", function() widgets.centered_float(widgets.scopes) end,                            desc = "Show scopes" },
    { "<F5>",       function() dap.continue() end,                                                    desc = "Continue debugging" },
    { "<F10>",      function() dap.step_over() end,                                                   desc = "(Debug) Step over" },
    { "<F11>",      function() dap.step_into() end,                                                   desc = "(Debug) Step into" },
    { "<F12>",      function() dap.step_out() end,                                                    desc = "(Debug) Step out" },
    { "<C-b>",      function() dap.toggle_breakpoint() end,                                           desc = "(Debug) Toggle breakpoint" }
  })

  wk.add({
    mode = { 'n', 'v' },
    silent = true,
    { "<leader>dh", widgets.hover,   desc = "Hover" },
    { "<leader>dp", widgets.preview, desc = "Preview" }
  })
end

local debug_ports = {
  ["cosmos"] = 37910,
  ["gateway"] = 37911,
  ["admin"] = 37912,
  ["base"] = 37913,
  ["export"] = 37914,
  ["public"] = 37915,
  ["reactor"] = 37916,
}

local dbg_prefix = 'l_'

function M.init_go()
  require("dap-go").setup()
  local dap = require("dap")
  for srv, port in pairs(debug_ports) do
    dap.adapters[dbg_prefix .. srv] = {
      type = 'server',
      host = '127.0.0.1',
      port = tostring(port)
    }

    table.insert(dap.configurations.go, {
      type = dbg_prefix .. srv,
      name = 'Attach remote (' .. srv .. ')',
      mode = 'remote',
      request = 'attach'
    })
  end
end

return M
