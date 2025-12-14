-- Set leader
vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Clear highligts on search
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Copy filename
vim.keymap.set("n", "<leader>yf", function()
	local file = vim.fn.expand("%:t")
	vim.fn.setreg("+", file)
	print("Copied filename:", file)
end,
{ desc = "Copy filename" })

-- Copy filepath
vim.keymap.set("n", "<leader>yF", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("Copied filepath:", path)
end,
{ desc = "Copy absolute filepath" })

-- Open file under cursor (modified to use absolute path)
local function open_cfile()
    local path = vim.fn.expand("<cfile>")
    if path:match("^http") then
        vim.ui.open(path)
    else
        local abs = vim.fn.expand("%:p:h") .. "/" .. path
        if vim.fn.filereadable(abs) == 1 then
            vim.ui.open(abs)
        else
            print("File not found: " .. abs)
        end
    end
end
vim.keymap.set("n", "gx", open_cfile, { silent = true })

-- Paste reference to image from clipboard (for X11)
local function paste_image()
    local mime = vim.fn.system("xclip -selection clipboard -t TARGETS -o")
    if not mime:match("image/png") then
        print("Image in clipboard not found")
        return
    end

    local file_dir = vim.fn.expand("%:p:h")
    local image_dir = file_dir .. "/images"
    vim.fn.mkdir(image_dir, "p")

    local filename = "pasted_" .. os.date("%Y%m%d_%H%M%S") .. ".png"
    local filepath = image_dir .. "/" .. filename

    local cmd = string.format("xclip -selection clipboard -t image/png -o > %s", vim.fn.shellescape(filepath))
    os.execute(cmd)

    local relpath = "images/" .. filename
    local link = "![](" .. relpath .. ")  "

    if vim.fn.mode():sub(1,1) == "i" then
        vim.api.nvim_feedkeys(link, "n", true) --insert mode
    else
        vim.api.nvim_put({ link }, "c", true, true) --normal mode
    end
end
vim.keymap.set("n", "<leader>p", paste_image, { desc = "Paste image from clipboard into Markdown" })
vim.keymap.set("i", "<C-P>", paste_image, { desc = "Paste image from clipboard into Markdown" })

-- Additional yanking and deleting
vim.keymap.set("n", "Y", "y$", { desc = "Yank until EOL" })

-- Center screen when jumping
--vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
--vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("n", "<S-g>", "<S-g>zz", { desc = "Go to the bottom (centered)" })

-- Buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Right>", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-Left>", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bb", ":b#<CR>", { desc = "Recent buffer" }) --recent buffer is kept in `#` register (ctrl-^ also works)
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })
-- delete others: https://github.com/lukas-reineke/dotfiles/blob/master/vim/lua/buffers.lua

-- Tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tq', ':tabclose<CR>', { desc = 'Close tab' })

-- Windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resizing windows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-Down>" , ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<A-Up>" , ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-Down>" , ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "<A-Up>" , ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Popup menu navigation
vim.keymap.set({ "i", "c" }, "<Up>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or"<Up>" end, { expr = true })
vim.keymap.set({ "i", "c" }, "<Down>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or"<Down>" end, { expr = true })
vim.keymap.set({ "i", "c" }, "<Right>", function()
    return vim.fn.pumvisible() == 1 and "<C-y>" or"<Right>" end, { expr = true })
vim.keymap.set({ "i", "c" }, "<Left>", function()
    return vim.fn.pumvisible() == 1 and "<C-e>" or"<Left>" end, { expr = true })

-- Fzf and grep
vim.keymap.set("n", "<leader>ff", ":lua require('fzf-lua').files()<CR>", { desc = "Search in cwd" })
vim.keymap.set("n", "<leader>fF", ":lua require('fzf-lua').files({ no_ignore = true })<CR>", { desc = "Search ALL in cwd" })
vim.keymap.set("n", "<leader>fh", ":lua require('fzf-lua').files({ cwd = '~/' })<CR>", { desc = "Search sweet $HOME" })
vim.keymap.set("n", "<leader>f.", ":lua require('fzf-lua').files({ cwd = '~/dotfiles' })<CR>", { desc = "Search dotfiles" })
vim.keymap.set("n", "<leader>fc", ":lua require('fzf-lua').files({ cwd = '~/.config' })<CR>", { desc = "Search .config" })
vim.keymap.set("n", "<leader>fl", ":lua require('fzf-lua').files({ cwd = '~/.local' })<CR>", { desc = "Search .local" })
vim.keymap.set("n", "<leader>fp", ":lua require('fzf-lua').files({ cwd = '~/Projects' })<CR>", { desc = "Search projects" })
--vim.keymap.set("n", "<leader>ff", ":lua require('fzf-lua').files({ cwd = '..' })<CR>", { desc = "" })
vim.keymap.set("n", "<leader>fr", ":lua require('fzf-lua').resume()<CR>", { desc = "Search resume" })
vim.keymap.set("n", "<leader>fb", ":lua require('fzf-lua').buffers()<CR>", { desc = "Search buffers" })
vim.keymap.set("n", "<leader>F", ":FzfLua global<CR>", { desc = "Search files, buffers, LSP symbols" })
vim.keymap.set("n", "<leader>fz", ":FzfLua<CR>", { desc = "FzfLua" })
vim.keymap.set("n", "<leader>g", ":lua require('fzf-lua').grep()<CR>", { desc = "Search strings/regexes" })
vim.keymap.set("n", "<leader>G", ":lua require('fzf-lua').grep_cword()<CR>", { desc = "Grep word/WORD under cursor" })

-- Misc
vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" }) --save file but q u i c k e r
vim.keymap.set("n", "<leader>W", ":wa<CR>", { desc = "Save all" }) --save all files (buffers)
vim.keymap.set("n", "ZZ", "ZZ", { desc = "Save and close" })
vim.keymap.set("n", "ZA", ":confirm wqall<CR>", { desc = "Save all and exit" }) --save all buffers and exit
vim.keymap.set("n", "J", function() return "mz" .. vim.v.count1 .. "J`z" end, { expr = true, desc = "Join line below" }) --keep cursor position when joining lines
vim.keymap.set("n", "<leader>z", ":lua require('no-neck-pain').toggle()<CR>", { desc = "Toggle centering" }) --toggle zenmode
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor (<C-c> to cancel)"}) --replace word under cursor, <C-c> to cancel
vim.keymap.set({ "n", "v" }, "<leader>!", ":'<,'>w !sh<CR>", { desc = "Execute current line(s) as shell command" })

