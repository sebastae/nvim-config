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

  dap.listeners.before.launch.dapui_config = function()
    dui.open()
  end

  dap.listeners.before.event_terminated.dapui_config = function()
    dui.close()
  end

  dap.listeners.before.event_exited.dapui_config = function()
    dui.close()
  end
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

local pkg_root = '/home/sebastian/luxsave/cms/go'
local debug_packages = {
  ["cosmos"] = pkg_root .. '/cosmos',
  ["gateway"] = pkg_root .. '/gateway',
  ["base"] = pkg_root .. '/base'
}

local function attach_or_toggle()
  local dui = require("dapui")
  local dap = require("dap")

  local session = dap.session()
  if session then
    dui.open()
    dap.continue()
    return
  end

  local net = require("util.net")
  for service, port in pairs(debug_ports) do
    if net.is_port_open(port) then
      dap.run({
        name = 'Attach ' .. service,
        request = "attach",
        type = "delve",
        delve = {
          port = tostring(port),
        },
      })
      return
    end
  end

  vim.notify("No active debug ports found", vim.log.levels.WARN)
end

local function get_service_port(config)
  local dap = require("dap")
  return coroutine.create(function(dap_run_co)
    vim.ui.select(vim.tbl_keys(debug_ports), { prompt = "Pick service" }, function(service)
      if debug_ports[service] == nil then vim.notify("No port selected, aborting", vim.log.levels.INFO) end
      coroutine.resume(dap_run_co, debug_ports[service] or dap.ABORT)
    end)
  end)
end


local function get_package_dirname(config)
  local bufdir = vim.fs.dirname(vim.fn.bufname())
  if bufdir:gmatch('^%.') then
    bufdir = './' .. bufdir
  end
  local dirs = vim.fs.find({ 'go.mod' }, {
    stop = '.git',
    upward = true,
    path = bufdir
  })

  for k, v in ipairs(dirs) do
    local dn = vim.fs.dirname(v)
    if not dn:gmatch('^/') then
      dn = './' .. dn
    end
    dirs[k] = dn
  end

  if #dirs == 0 then
    vim.notify("The current buffer does not belong to a go package, aborting", vim.log.levels.WARN)
    return require("dap").ABORT
  elseif #dirs == 1 then
    return dirs[1]
  else
    return coroutine.create(function(dap_run_co)
      vim.ui.select(dirs, { prompt = "Pick package" }, function(item)
        coroutine.resume(dap_run_co, item or require("dap").ABORT)
      end)
    end)
  end
end


function M.init_go()
  local dap = require("dap")
  require("dap-go").setup({})

  dap.adapters.delve = function(callback, config)
    local port = config.port or '${port}'
    local host = config.host or '127.0.0.1'

    local listener_addr = host .. ':' .. port

    config.delve = config.delve or {}

    callback({
      type = "server",
      port = port,
      executable = {
        command = "dlv",
        args = { "dap", "-l", listener_addr },
        detached = true,
        cwd = config.delve.cwd
      },
      options = {
        initialize_timeout_sec = 20
      }
    })
  end

  dap.configurations.go = {}

  table.insert(dap.configurations.go, {
    type = 'delve',
    name = 'Attach to service',
    mode = 'remote',
    request = 'attach',
    port = get_service_port
  })

  --[[
  table.insert(dap.configurations.go, {
    name = 'Debug current package',
    type = 'delve',
    request = 'launch',
    mode = 'debug',
    program = '.',
    delve = {
      cwd = get_package_dirname,
    },
    outputMode = "remote"
  })]]

  table.insert(dap.configurations.go, {
    name = 'Debug package',
    type = 'delve',
    request = 'launch',
    mode = 'debug',
    program = '.',
    delve = {
      cwd = function()
        return coroutine.create(function(dap_run_co)
          vim.ui.select(vim.tbl_keys(debug_packages), { prompt = "Pick package" }, function(item)
            print("Selected [" .. item .. "]: " .. debug_packages[item])
            coroutine.resume(dap_run_co, debug_packages[item] or dap.ABORT)
          end)
        end)
      end
    },
    outputMode = 'remote'
  })
end

local function toggle_special_breakpoint()
  local dap = require "dap"
  vim.ui.select({ "Log point", "Conditional breakpoint" }, { prompt = "Special breakpoint" }, function(item)
    if item == "Log point" then
      dap.toggle_breakpoint(vim.fn.input("Breakpoint condition: "))
    elseif item == "Conditional breakpoint" then
      dap.toggle_breakpoint(nil, nil, vim.fn.input("Log message: "))
    end
  end)
end

local function select_test_debug()
  local dg = require("dap-go")
  vim.ui.select({
    { "Debug closest test", dg.debug_test },
    { "Debug last test",    dg.debug_last_test },
  }, { prompt = "Select test debug", format_item = function(item) return item[1] end }, function(item)
    if item then
      item[2]()
    end
  end)
end

function M.init_dap()
  local widgets = require("dap.ui.widgets")
  local wk      = require("which-key")
  local dap     = require("dap")

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
    { "<leader>dT", select_test_debug,                                                                desc = "Debug test" },
    { "<F5>",       function() dap.continue() end,                                                    desc = "Continue debugging" },
    { "<F10>",      function() dap.step_over() end,                                                   desc = "(Debug) Step over" },
    { "<F11>",      function() dap.step_into() end,                                                   desc = "(Debug) Step into" },
    { "<F12>",      function() dap.step_out() end,                                                    desc = "(Debug) Step out" },
    { "<C-b>",      function() dap.toggle_breakpoint() end,                                           desc = "(Debug) Toggle breakpoint" },
    { "<C-d>",      attach_or_toggle,                                                                 desc = "(Debug) Auto-attach or toggle UI" },
  })

  wk.add({
    mode = { 'n', 'v' },
    silent = true,
    { "<leader>dh", widgets.hover,   desc = "Hover" },
    { "<leader>dp", widgets.preview, desc = "Preview" }
  })
end

return M
