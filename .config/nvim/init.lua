--- [ Useful Functions ] ---

-- Copy Full File-Path
vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end)

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar", "*.d"  })

-- Better diff options
vim.opt.diffopt:append("linematch:60")

-- Performance improvements
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

--- [ Status line ] ---

-- Show current git branch
-- WARNING: `git branch` is run inside dir in which Nvim was opened
local function git_branch()
    local filepath = vim.fn.expand("%:p")
    local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    if branch ~= "" then
        return "[" .. branch .. "]"
    end
    return ""
end

-- File type with icon
local function file_type()
    local ft = vim.bo.filetype
    local icons = {
        lua = "lua",
        python = "py",
        javascript = "js",
        html = "html",
        css = "css",
        json = "json",
        markdown = "md",
        vim = "vim",
        sh = "sh",
    }

    if ft == "" then
        return "  "
    end

    return (icons[ft] or ft)
end

-- Mode indicators with icons
local function mode_icon()
    local mode = vim.fn.mode()
    local modes = {
        n = "NORMAL",
        i = "INSERT",
        v = "VISUAL",
        V = "V-LINE",
        ["\22"] = "V-BLOCK",  -- Ctrl-V
        c = "COMMAND",
        s = "SELECT",
        S = "S-LINE",
        ["\19"] = "S-BLOCK",  -- Ctrl-S
        R = "REPLACE",
        r = "REPLACE",
        ["!"] = "SHELL",
        t = "TERMINAL"
    }
    return modes[mode] or "  " .. mode:upper()
end

-- Word count for text files
local function word_count()
    local ft = vim.bo.filetype
    if ft == "markdown" or ft == "text" or ft == "tex" then
        local words = vim.fn.wordcount().words
        return "  " .. words .. " words "
    end
    return ""
end

-- File size
local function file_size()
    local size = vim.fn.getfsize(vim.fn.expand('%'))
    if size < 0 then return "" end
    if size < 1024 then
        return size .. "B "
    elseif size < 1024 * 1024 then
        return string.format("%.1fK", size / 1024)
    else
        return string.format("%.1fM", size / 1024 / 1024)
    end
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[
    highlight StatusLineBold gui=bold cterm=bold
]])

local function setup_dynamic_statusline()
    vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
        callback = function()
        vim.opt_local.statusline = table.concat {
            "  ",
            "%#StatusLineBold#",
            "%{v:lua.mode_icon()}",
            "%#StatusLine#",
            " │ ",
            "%f %h%m%r",
            "%{v:lua.git_branch()}",
            "%=",                     -- Right-align everything after this
            "%{v:lua.file_type()}  ",
            "%{v:lua.file_size()}  ",
            "%l:%c  %P ",             -- Line:Column and Percentage
        }
        end
    })
    vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

    vim.api.nvim_create_autocmd({"WinLeave", "BufLeave"}, {
    callback = function()
        vim.opt_local.statusline = "  %f %h%m%r  %=  %{v:lua.file_type()}  %l:%c  %P "
    end
    })
end

setup_dynamic_statusline()

--- [ Floating terminal ] ---

-- terminal
local terminal_state = {
    buf = nil,
    win = nil,
    is_open = false
}

local function FloatingTerminal()
    -- If terminal is already open, close it (toggle behavior)
    if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
        return
    end

    -- Create buffer if it doesn't exist or is invalid
    if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
        terminal_state.buf = vim.api.nvim_create_buf(false, true)
        -- Set buffer options for better terminal experience
        vim.api.nvim_buf_set_option(terminal_state.buf, 'bufhidden', 'hide')
    end

    -- Calculate window dimensions
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create the floating window
    terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'single',
    })

    -- Set transparency for the floating window
    vim.api.nvim_win_set_option(terminal_state.win, 'winblend', 0)

    -- Set transparent background for the window
    vim.api.nvim_win_set_option(terminal_state.win, 'winhighlight',
    'Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder')

    -- Define highlight groups for transparency
    vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none", })

    -- Start terminal if not already running
    local has_terminal = false
    local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
    for _, line in ipairs(lines) do
        if line ~= "" then
            has_terminal = true
            break
        end
    end

    if not has_terminal then
        vim.fn.termopen(os.getenv("SHELL"))
    end

    terminal_state.is_open = true
    vim.cmd("startinsert")

    -- Set up auto-close on buffer leave 
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = terminal_state.buf,
        callback = function()
            if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
                vim.api.nvim_win_close(terminal_state.win, false)
                terminal_state.is_open = false
            end
        end,
        once = true
    })
end

-- Function to explicitly close the terminal
local function CloseFloatingTerminal()
    if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
    end
end

-- Key mappings
vim.keymap.set("n", "<leader><Enter>", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", function()
    if terminal_state.is_open then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
    end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })

--- [ Tabs ] ---

-- Tab display settings
vim.opt.showtabline = 1  -- Always show tabline (0=never, 1=when multiple tabs, 2=always)
vim.opt.tabline = ''     -- Use default tabline (empty string uses built-in)

-- Transparent tabline appearance
vim.cmd([[
    hi TabLineFill guibg=NONE ctermfg=242 ctermbg=NONE
]])

-- Alternative navigation (more intuitive)
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tq', ':tabclose<CR>', { desc = 'Close tab' })

-- Tab moving
vim.keymap.set('n', '<leader>tm', ':tabmove<CR>', { desc = 'Move tab' })
vim.keymap.set('n', '<leader>t>', ':tabmove +1<CR>', { desc = 'Move tab right' })
vim.keymap.set('n', '<leader>t<', ':tabmove -1<CR>', { desc = 'Move tab left' })

-- Function to open file in new tab
local function open_file_in_tab()
    vim.ui.input({ prompt = 'File to open in new tab: ', completion = 'file' }, function(input)
        if input and input ~= '' then
            vim.cmd('tabnew ' .. input)
        end
    end)
end

-- Function to duplicate current tab
local function duplicate_tab()
    local current_file = vim.fn.expand('%:p')
    if current_file ~= '' then
        vim.cmd('tabnew ' .. current_file)
    else
        vim.cmd('tabnew')
    end
end

-- Function to close tabs to the right
local function close_tabs_right()
    local current_tab = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr('$')

    for i = last_tab, current_tab + 1, -1 do
        vim.cmd(i .. 'tabclose')
    end
end

-- Function to close tabs to the left
local function close_tabs_left()
    local current_tab = vim.fn.tabpagenr()

    for i = current_tab - 1, 1, -1 do
        vim.cmd('1tabclose')
    end
end

-- Enhanced keybindings
vim.keymap.set('n', '<leader>te', open_file_in_tab, { desc = 'Open file in new tab' })
vim.keymap.set('n', '<leader>ty', duplicate_tab, { desc = 'Duplicate current tab' })
vim.keymap.set('n', '<leader>tcr', close_tabs_right, { desc = 'Close tabs to the right' })
vim.keymap.set('n', '<leader>tcl', close_tabs_left, { desc = 'Close tabs to the left' })

-- Function to close buffer but keep tab if it's the only buffer in tab
local function smart_close_buffer()
    local buffers_in_tab = #vim.fn.tabpagebuflist()
    if buffers_in_tab > 1 then
        vim.cmd('bdelete')
    else
        -- If it's the only buffer in tab, close the tab
        vim.cmd('tabclose')
    end
end
vim.keymap.set('n', '<leader>bd', smart_close_buffer, { desc = 'Smart close buffer/tab' })

-- Load configs from different files
require("config.theme")
require("config.keymappings")
require("config.options")
require("config.autocmd")
