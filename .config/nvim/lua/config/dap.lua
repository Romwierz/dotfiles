-- Notes:
--
-- When using internalConsole/integratedTerminal as a program output, it may be required to alter
-- stream buffering.
--
-- For example, in C/C++ DAP's REPL window is not treated as a regular terminal,
-- so the output stream is not line buffered which is the default for terminals. Instead it's
-- block buffered, so the data is not sent after newline. To get the data sent to stdout being
-- diplayed, setbuf() can be used:
-- ```
--   #ifdef DEBUG
--       setbuf(stdout, NULL);
--   #endif
-- ```
-- It essentially turns off the buffering of the stdout stream. Other option is to sent the
-- debug information to stderr which is always unbuffered on default:
-- `fprintf(stderr, "Co to sie stanelo\n")`

local dap = require("dap")
local dap_view = require("dap-view")
local dapui = require("dapui")

-- DAP
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = os.getenv('HOME') .. '/.vscode/extensions/ms-vscode.cpptools-1.29.3-linux-x64/debugAdapters/bin/OpenDebugAD7',
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
        -- Seems like returning a single string containing multiple args works
        return vim.fn.input('Arguments passed to the program: ')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = true,
    console = 'externalTerminal',
  },
  {
    name = "Launch (cppdbg)",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function ()
        local str = vim.fn.input('Arguments passed to the program: ')
        return vim.split(str, " ")
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
    console = 'integratedTerminal',
    setupCommands = {
        {
            text = '-enable-pretty-printing',
            description =  'enable pretty printing',
            ignoreFailures = false
        },
    },
  },
  {
    name = "Select and attach to process",
    type = "gdb",
    request = "attach",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    pid = function()
      local name = vim.fn.input('Executable name (filter): ')
      return require("dap.utils").pick_process({ filter = name })
    end,
    cwd = '${workspaceFolder}'
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'gdb',
    request = 'attach',
    target = 'localhost:1234',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}'
  }
}

-- DAP View
dap_view.setup({
    winbar = {
        default_section = "scopes",
        custom_sections = { "disassembly" },
    },
    windows = {
        position = function(prev)
            ---@param layout vim.fn.winlayout.ret
            ---@return boolean
            local function layout_has_vsplit(layout)
                local type = layout[1]
                if type == "leaf" then
                    return false
                elseif type == "row" then
                    return true
                else -- "col"
                    ---@cast layout[2] (vim.fn.winlayout.branch|vim.fn.winlayout.leaf)[]
                    for _, child in ipairs(layout[2]) do
                        if layout_has_vsplit(child) then
                            return true
                        end
                    end
                    return false
                end
            end

            local vsplit = layout_has_vsplit(vim.fn.winlayout())

            return vsplit and "below" or "right"
        end,
    }
})

-- DAP UI
dapui.setup({
    layouts = { {
        elements = { {
            id = "scopes",
            size = 0.25
          }, {
            id = "breakpoints",
            size = 0.25
          }, {
            id = "stacks",
            size = 0.25
          }, {
            id = "watches",
            size = 0.25
          } },
        position = "left",
        size = 40
      }, {
        elements = { {
            id = "repl",
            size = 1.0
          },
          -- {
          --   id = "console",
          --   size = 0.5
          -- }
      },
        position = "bottom",
        size = 20
      } },
})

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- Keymappings
local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { desc = 'DAP: ' .. desc })
end

local function dap_view_toggle()
    require("no-neck-pain").toggle()
    -- Defer to make sure the layout is properyly rebuilt by NNP
    vim.defer_fn(function()
        dap_view.toggle()
    end, 20)
end

local function dapui_toggle()
    require("no-neck-pain").toggle()
    -- Defer to make sure the layout is properyly rebuilt by NNP
    vim.defer_fn(function()
        dapui.toggle()
    end, 20)
end

map('<leader>dc', dap.continue, 'Start/continue')
map('<leader>dC', dap.run_last, 'Run last')
map('<leader>db', dap.toggle_breakpoint, 'Toggle breakpoint')
map('<leader>de', function() dap.set_exception_breakpoints({ 'all' }) end, 'Toggle breakpoint')
map('<leader>dn', dap.step_over, 'Step over')
map('<leader>ds', dap.step_into, 'Step into')
map('<leader>dS', dap.step_out, 'Step out')
map('<leader>dv', dapui_toggle, 'Toggle DAP UI')
map('<leader>dq', function() require("dap").terminate(); require("dapui").close() end, 'Terminate')
map('<leader>dk', dapui.eval, 'Evaluate expr under cursor', { 'n', 'v' })

-- Signs
for _, group in pairs({
    "DapBreakpoint",
    "DapBreakpointCondition",
    "DapBreakpointRejected",
    "DapLogPoint",
}) do
    vim.fn.sign_define(group, { text = "●" })
end
vim.fn.sign_define("DapStopped", { text = "", numhl = "debugPC" })
