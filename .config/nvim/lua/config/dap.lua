local dap = require("dap")
local dap_view = require("dap-view")

-- DAP
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
}

dap.configurations.c = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function() -- provide arguments if needed
        -- Seems like returning a single string containing multiple args works
        return vim.fn.input('Arguments passed to the program: ')
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = true,
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

map('<leader>dc', dap.continue, 'Start/continue')
map('<leader>dC', dap.run_last, 'Run last')
map('<leader>db', dap.toggle_breakpoint, 'Toggle breakpoint')
map('<leader>dn', dap.step_over, 'Step over')
map('<leader>ds', dap.step_into, 'Step into')
map('<leader>dv', dap_view_toggle, 'Toggle DAP View')

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
