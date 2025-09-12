-- Auto install vim-plug and plugins if not found
local data_dir = vim.fn.stdpath('data')
if vim.fn.empty(vim.fn.glob(data_dir .. '/site/autoload/plug.vim')) == 1 then
vim.cmd('silent !curl -fLo ' .. data_dir .. '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
	vim.o.runtimepath = vim.o.runtimepath
	vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

local vim = vim
local Plug = vim.fn['plug#']

vim.g.start_time = vim.fn.reltime()
vim.loader.enable() --  SPEEEEEEEEEEED 
vim.call('plug#begin')

-- Themes
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
Plug('ellisonleao/gruvbox.nvim', { ['as'] = 'gruvbox' })

Plug('norcalli/nvim-colorizer.lua') --color highlight
Plug('lewis6991/gitsigns.nvim') --git
Plug('nvim-lualine/lualine.nvim') --statusline
Plug('nvim-tree/nvim-web-devicons') --pretty icons
Plug('nvim-treesitter/nvim-treesitter') --improved syntax
Plug('windwp/nvim-autopairs') --autopairs
Plug('ibhagwan/fzf-lua') --fuzzy finder and grep
Plug('folke/zen-mode.nvim') --zen-mode
Plug('MeanderingProgrammer/render-markdown.nvim') --render md inline

vim.call('plug#end')

-- Load configs from different files
require("config.theme")
require("config.keymappings")
require("config.options")
require("config.autocmd")

require("plugins.colorizer")
require("plugins.colorscheme")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.treesitter")
require("plugins.autopairs")
require("plugins.fzf-lua")

load_theme()

if vim.env.NVIM_MODE == "notes" then
    vim.opt.bg = 'light'
    vim.cmd("colorscheme gruvbox")
    require("lualine").setup({ options = { theme =  "gruvbox" } })
    require("plugins.render-markdown")
    vim.cmd("Gitsigns toggle_signs")
end
