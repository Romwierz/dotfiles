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
	print("copied filename:", file)
end)

-- Copy filepath
vim.keymap.set("n", "<leader>yF", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("copied filepath:", path)
end)

-- Additional yanking and deleting
vim.keymap.set("n", "Y", "y$", { desc = "Yank until EOL" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

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
vim.keymap.set("n", "<leader>q" , ":bdelete<CR>", { desc = "Delete buffer" })
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
vim.keymap.set("n", "<leader>ff", ":lua require('fzf-lua').files()<CR>") --search cwd
vim.keymap.set("n", "<leader>fh", ":lua require('fzf-lua').files({ cwd = '~/' })<CR>") --search home
vim.keymap.set("n", "<leader>f.", ":lua require('fzf-lua').files({ cwd = '~/dotfiles' })<CR>") --search dotfiles
vim.keymap.set("n", "<leader>fc", ":lua require('fzf-lua').files({ cwd = '~/.config' })<CR>") --search .config
vim.keymap.set("n", "<leader>fl", ":lua require('fzf-lua').files({ cwd = '~/.local' })<CR>") --search .local
--vim.keymap.set("n", "<leader>ff", ":lua require('fzf-lua').files({ cwd = '..' })<CR>") --search above
vim.keymap.set("n", "<leader>fr", ":lua require('fzf-lua').resume()<CR>") --last search
vim.keymap.set("n", "<leader>fb", ":lua require('fzf-lua').buffers()<CR>") --search buffers
vim.keymap.set("n", "<leader>F", ":FzfLua global<CR>") --search files, buffers and LSP symbols (VSCode like)
vim.keymap.set("n", "<leader>fz", ":FzfLua<CR>") --just FzfLua
vim.keymap.set("n", "<leader>g", ":lua require('fzf-lua').grep()<CR>") --grep
vim.keymap.set("n", "<leader>G", ":lua require('fzf-lua').grep_cword()<CR>") --grep word under cursor

-- Misc
vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>p", switch_theme) --cycle themes
vim.keymap.set("n", "<leader>w", ":w<CR>") --save file but q u i c k e r
vim.keymap.set("n", "<leader>W", ":wa<CR>") --save all files (buffers)
vim.keymap.set("n", "J", "mzJ`z") --keep cursor position when joining lines
vim.keymap.set("n", "<leader>z", ":lua require('zen-mode').toggle()<CR>") --toggle zenmode
