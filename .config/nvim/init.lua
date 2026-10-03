-- Get device-specific configuration
local success, local_config = pcall(require, 'local')
if success and local_config.machine_type == "server" then
    return
else if not success then
    print('Local config not detected')
end
end

vim.g.start_time = vim.fn.reltime()
-- This may cause issues
-- vim.loader.enable() --  SPEEEEEEEEEEED 

local gh = function(x) return 'https://github.com/' .. x end

-- Themes and UI
vim.pack.add({
    gh('catppuccin/nvim'),
    gh('ellisonleao/gruvbox.nvim'),
    gh('norcalli/nvim-colorizer.lua'), --color highlight
    gh('nvim-lualine/lualine.nvim'), --statusline
    gh('nvim-tree/nvim-web-devicons'), --pretty icons
    gh('folke/which-key.nvim') --mappings popup
})

-- Uncategorized
vim.pack.add({
    gh('lewis6991/gitsigns.nvim'), --git
    { src = gh('nvim-treesitter/nvim-treesitter'), version = 'master'},
    gh('windwp/nvim-autopairs'),
    gh('ibhagwan/fzf-lua'), --fuzzy finder and grep
    gh('shortcuts/no-neck-pain.nvim'),
    gh('MeanderingProgrammer/render-markdown.nvim'), --render md inline
    gh("rafamadriz/friendly-snippets"),
    gh('christoomey/vim-tmux-navigator'),
    gh('kylechui/nvim-surround'),
})

-- -- LSP stuff
vim.pack.add({
    gh('mason-org/mason.nvim'),
    gh('mason-org/mason-lspconfig.nvim'),
    gh('neovim/nvim-lspconfig'),
    { src = gh('saghen/blink.cmp'), version = 'v1'}
})

-- -- Load configs from different files
require("config.theme")
require("config.keymappings")
require("config.options")
require("config.autocmd")
require("config.utils")

require("plugins.colorizer")
require("plugins.colorscheme")
require("plugins.gitsigns")
require("plugins.lualine")
require("plugins.treesitter")
require("plugins.autopairs")
require("plugins.fzf-lua")
require("plugins.no-neck-pain")
require("plugins.blink")

require("config.lsp")

require("plugins.which-key")

load_theme()

if vim.env.NVIM_MODE == "notes" then
    require("plugins.render-markdown")
    vim.cmd("Gitsigns toggle_signs")
    if local_config.notes_theme == 'light' then
        vim.opt.bg = 'light'
        vim.cmd("colorscheme gruvbox")
        require("lualine").setup({ options = { theme = "gruvbox" } })
    end
end
