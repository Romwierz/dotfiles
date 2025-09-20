-- Basic settings
vim.opt.number = true                               -- Line numbers
vim.opt.relativenumber = true                       -- Relative line numbers
vim.opt.cursorline = true                           -- Highlight current line
vim.opt.wrap = false                                -- Don't wrap lines
vim.opt.scrolloff = 10                              -- Keep 10 lines above/below cursor 
vim.opt.sidescrolloff = 8                           -- Keep 8 columns left/right of cursor

-- Indentation
vim.opt.tabstop = 4                                 -- Tab width
vim.opt.shiftwidth = 4                              -- Indent width
vim.opt.softtabstop = 4                             -- Soft tab stop
vim.opt.expandtab = true                            -- Use spaces instead of tabs
vim.opt.smartindent = true                          -- Smart auto-indenting
vim.opt.autoindent = true                           -- Copy indent from current line

-- Search settings
vim.opt.ignorecase = true                           -- Case insensitive search
vim.opt.smartcase = true                            -- Case sensitive if uppercase in search
vim.opt.hlsearch = true                             -- Highlight search results 
vim.opt.incsearch = true                            -- Show matches as you type

-- Visual settings
vim.opt.termguicolors = true                        -- Enable 24-bit colors
vim.opt.signcolumn = "yes"                          -- Always show sign column
vim.opt.showmatch = true                            -- Highlight matching brackets
vim.opt.matchtime = 2                               -- How long to show matching bracket
vim.opt.cmdheight = 1                               -- Command line height
vim.opt.completeopt = "menuone,noinsert,noselect"   -- Completion options 
vim.opt.showmode = false                            -- Don't show mode in command line 
vim.opt.pumheight = 10                              -- Popup menu height 
vim.opt.pumblend = 10                               -- Popup menu transparency 
vim.opt.winblend = 0                                -- Floating window transparency 
vim.opt.conceallevel = 0                            -- Don't hide markup 
vim.opt.concealcursor = ""                          -- Don't hide cursor line markup 
vim.opt.lazyredraw = true                           -- Don't redraw during macros
vim.opt.synmaxcol = 300                             -- Syntax highlighting limit
-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Folding
--vim.opt.foldmethod = "expr"                             -- Use expression for folding
--vim.wo.vim.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
vim.opt.foldlevel = 99
-- Tab display settings
vim.opt.showtabline = 1                             -- Always show tabline (0=never, 1=when multiple tabs, 2=always)
vim.opt.tabline = ''                                -- Use default tabline (empty string uses built-in)
-- Transparent tabline appearance
vim.cmd([[ hi TabLineFill guibg=NONE ctermfg=242 ctermbg=NONE ]])
vim.api.nvim_set_hl(0, "FoldColumn", { link = "Normal" })
vim.g.have_nerd_font = true

-- File handling
vim.opt.backup = false                             -- Don't create backup files
vim.opt.writebackup = false                        -- Don't create backup before writing
vim.opt.swapfile = false                           -- Don't create swap files
vim.opt.undofile = true                            -- Persistent undo
--vim.opt.undodir = vim.fn.expand("~/.vim/undodir")  -- Undo directory
vim.opt.updatetime = 300                           -- Faster completion
vim.opt.timeoutlen = 3000                          -- Key timeout duration
vim.opt.ttimeoutlen = 0                            -- Key code timeout
vim.opt.autoread = true                            -- Auto reload files changed outside vim
vim.opt.autowrite = false                          -- Don't auto save
vim.o.confirm = true                               -- Raise a dialog asking to save the current file(s)

-- Behavior settings
vim.opt.hidden = true                              -- Allow hidden buffers
vim.opt.errorbells = false                         -- No error bells
vim.opt.backspace = "indent,eol,start"             -- Better backspace behavior
vim.opt.autochdir = false                          -- Don't auto change directory
vim.opt.iskeyword:append("-")                      -- Treat dash as part of word
vim.opt.path:append("**")                          -- include subdirectories in search
vim.opt.selection = "exclusive"                    -- Selection behavior
vim.opt.mouse = "a"                                -- Enable mouse support
vim.opt.clipboard:append("unnamedplus")            -- Use system clipboard
vim.opt.modifiable = true                          -- Allow buffer modifications
vim.opt.encoding = "UTF-8"                         -- Set encoding
vim.g.loaded_netrw = 1; vim.g.loaded_netrw = 1     -- Disable netrw to use other file explorer
-- Cursor settings
--vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar", "*.d"  })

-- Better diff options
vim.opt.diffopt:append("linematch:60")

-- Performance improvements
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

