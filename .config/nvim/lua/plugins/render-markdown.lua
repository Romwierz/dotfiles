-- Icons: https://www.nerdfonts.com/cheat-sheet
--█

-- Fold lines with links (folding is visible only if a line doesn' fit on a screen)
-- Use `zc` and `zv` to fold/unfold
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.md",
    callback = function()
        -- Get original mark (last position before closing a file)
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lines = vim.api.nvim_buf_line_count(0)
        for lnum = 1, lines do
            local line = vim.fn.getline(lnum)
            if line:match("%[[^]]*%]%([^)]*%)") and not line:match("^%s*#") then
                vim.api.nvim_win_set_cursor(0, { lnum, 0 })
                vim.cmd("normal! zf$")
            end
        end
        -- Go back to the original mark after folding all matched lines
        if mark[1] > 0 and mark[1] <= lines then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

require('render-markdown').setup({
    on = {
        attach = function()
            vim.opt.cursorline = false
            vim.opt.number = false
            vim.opt.relativenumber = false
            -- display '\-' at the beginning of the line as '-'
            vim.cmd([[syn match markdownEscapeHyphen /^\zs\\\ze-/ conceal]])
            -- display '234\)' as '234)'
            vim.cmd([[syn match markdownEscapeParen /^\d\+\zs\\\ze)/ conceal]])
            -- turn '->' into '→'
            vim.cmd.iabbrev("->", "→")
            vim.cmd.iabbrev("<-", "←")
        end,
        initial = function()
            vim.opt.bg = 'light'
            vim.cmd("colorscheme gruvbox")
            require("lualine").setup({ options = { theme =  "gruvbox" } })
            vim.api.nvim_set_hl(0, "@string", { fg = "#928374" })
            vim.api.nvim_set_hl(0, "String", { fg = "#928374", bg = "NONE", italic = true })
        end,
        render = function()
            vim.opt.wrap = true
            vim.opt.linebreak = true
            vim.opt.breakindent = true
        end
    },
    heading = {
        icons = { '', '', '', '', '', '' },
        sign = false,
        position = 'inline',
        width = 'block',
        left_pad = 2,
        right_pad = 2,
        backgrounds = {
            'RenderMarkdownH1Bg',
            'RenderMarkdownH2Bg',
            'RenderMarkdownH3Bg',
            '',
            '',
            '',
        },
        -- Highlight for the heading and sign icons.
        -- Output is evaluated using the same logic as 'backgrounds'.
        foregrounds = {
            'RenderMarkdownH1',
            'RenderMarkdownH2',
            'RenderMarkdownH3',
            'RenderMarkdownH4',
            'RenderMarkdownH5',
            'RenderMarkdownH6',
        },
    },
    code = {
        sign = false,
        width = 'block',
        min_width = 45,
        left_pad = 2,
        language_pad = 0,
        language_border = ' ',
        language_left = '█',
        language_right = '█',
        border = 'thin',
        above = '',
        below = '',
        disable_background = true,
        inline = false,
    },
    dash = {
        width = 0.5,
    },
    bullet = {
        icons = { '', '○', '◆', '◇' },
        left_pad = 1,
    },
    checkbox = {
        -- doesn't work
        unchecked = {
            icon = '󰄱 ',
            highlight = 'RenderMarkdownUnchecked',
            scope_highlight = nil,
        },
        checked = {
            icon = '󰱒 ',
            icon = 'xxx ',
            highlight = 'RenderMarkdownChecked',
            scope_highlight = nil,
        },
        custom = {
            todo = { raw = '[-]', rendered = 'aaa', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
        },
    },
    pipe_table = {
        row = 'RenderMarkdownTableHead',
    },
    link = {
        -- Turn on / off inline link icon rendering.
        enabled = true,
        -- Additional modes to render links.
        render_modes = false,
        -- How to handle footnote links, start with a '^'.
        footnote = {
            -- Turn on / off footnote rendering.
            enabled = true,
            -- Replace value with superscript equivalent.
            superscript = true,
            -- Added before link content.
            prefix = '',
            -- Added after link content.
            suffix = '',
        },
        -- Inlined with 'image' elements.
        image = '󰥶 ',
        -- Inlined with 'email_autolink' elements.
        email = '󰀓 ',
        -- Fallback icon for 'inline_link' and 'uri_autolink' elements.
        hyperlink = '󰌹 ',
        -- Applies to the inlined icon as a fallback.
        highlight = 'RenderMarkdownLink',
        -- Applies to WikiLink elements.
        wiki = {
            icon = '󱗖 ',
            body = function()
                return nil
            end,
            highlight = 'RenderMarkdownWikiLink',
        },
        -- Define custom destination patterns so icons can quickly inform you of what a link
        -- contains. Applies to 'inline_link', 'uri_autolink', and wikilink nodes. When multiple
        -- patterns match a link the one with the longer pattern is used.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | pattern   | matched against the destination text                            |
        -- | icon      | gets inlined before the link text                               |
        -- | kind      | optional determines how pattern is checked                      |
        -- |           | pattern | @see :h lua-patterns, is the default if not set       |
        -- |           | suffix  | @see :h vim.endswith()                                |
        -- | priority  | optional used when multiple match, uses pattern length if empty |
        -- | highlight | optional highlight for 'icon', uses fallback highlight if empty |
        custom = {
            web = { pattern = '^http', icon = '󰖟 ' },
            github = { pattern = 'github%.com', icon = '󰊤 ' },
            gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
            stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
            wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
            youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
        },
    },
    callout = {
        -- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link'.
        -- The key is for healthcheck and to allow users to change its values, value type below.
        -- | raw        | matched against the raw text of a 'shortcut_link', case insensitive |
        -- | rendered   | replaces the 'raw' value when rendering                             |
        -- | highlight  | highlight for the 'rendered' text and quote markers                 |
        -- | quote_icon | optional override for quote.icon value for individual callout       |
        -- | category   | optional metadata useful for filtering                              |

        note      = { raw = '[!NOTE]',      rendered = '󰋽 Note',      highlight = 'RenderMarkdownInfo'},
        tip       = { raw = '[!TIP]',       rendered = '󰌶 Tip',       highlight = 'RenderMarkdownSuccess'},
        important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint'},
        warning   = { raw = '[!WARNING]',   rendered = '󰀪 Warning',   highlight = 'RenderMarkdownWarn'},
        caution   = { raw = '[!CAUTION]',   rendered = '󰳦 Caution',   highlight = 'RenderMarkdownError'},
        abstract  = { raw = '[!ABSTRACT]',  rendered = '󰨸 Abstract',  highlight = 'RenderMarkdownInfo'},
        summary   = { raw = '[!SUMMARY]',   rendered = '󰨸 Summary',   highlight = 'RenderMarkdownInfo'},
        tldr      = { raw = '[!TLDR]',      rendered = '󰨸 Tldr',      highlight = 'RenderMarkdownInfo'},
        info      = { raw = '[!INFO]',      rendered = '󰋽 Info',      highlight = 'RenderMarkdownInfo'},
        todo      = { raw = '[!TODO]',      rendered = '󰗡 Todo',      highlight = 'RenderMarkdownInfo'},
        hint      = { raw = '[!HINT]',      rendered = '󰌶 Hint',      highlight = 'RenderMarkdownSuccess'},
        success   = { raw = '[!SUCCESS]',   rendered = '󰄬 Success',   highlight = 'RenderMarkdownSuccess'},
        check     = { raw = '[!CHECK]',     rendered = '󰄬 Check',     highlight = 'RenderMarkdownSuccess'},
        done      = { raw = '[!DONE]',      rendered = '󰄬 Done',      highlight = 'RenderMarkdownSuccess'},
        question  = { raw = '[!QUESTION]',  rendered = '󰘥 Question',  highlight = 'RenderMarkdownWarn'},
        help      = { raw = '[!HELP]',      rendered = '󰘥 Help',      highlight = 'RenderMarkdownWarn'},
        faq       = { raw = '[!FAQ]',       rendered = '󰘥 Faq',       highlight = 'RenderMarkdownWarn'},
        attention = { raw = '[!ATTENTION]', rendered = '󰀪 Attention', highlight = 'RenderMarkdownWarn'},
        failure   = { raw = '[!FAILURE]',   rendered = '󰅖 Failure',   highlight = 'RenderMarkdownError'},
        fail      = { raw = '[!FAIL]',      rendered = '󰅖 Fail',      highlight = 'RenderMarkdownError'},
        missing   = { raw = '[!MISSING]',   rendered = '󰅖 Missing',   highlight = 'RenderMarkdownError'},
        danger    = { raw = '[!DANGER]',    rendered = '󱐌 Danger',    highlight = 'RenderMarkdownError'},
        error     = { raw = '[!ERROR]',     rendered = '󱐌 Error',     highlight = 'RenderMarkdownError'},
        bug       = { raw = '[!BUG]',       rendered = '󰨰 Bug',       highlight = 'RenderMarkdownError'},
        example   = { raw = '[!EXAMPLE]',   rendered = '󰉹 Example',   highlight = 'RenderMarkdownHint' },
        quote     = { raw = '[!QUOTE]',     rendered = '󱆨 Quote',     highlight = 'RenderMarkdownQuote'},
        cite      = { raw = '[!CITE]',      rendered = '󱆨 Cite',      highlight = 'RenderMarkdownQuote'},
    },
    quote = { icon = '▋' },
    anti_conceal = {
        enabled = true,
        -- Which elements to always show, ignoring anti conceal behavior. Values can either be
        -- booleans to fix the behavior or string lists representing modes where anti conceal
        -- behavior will be ignored. Valid values are:
        --   head_icon, head_background, head_border, code_language, code_background, code_border,
        --   dash, bullet, check_icon, check_scope, quote, table_border, callout, link, sign
        ignore = {
            code_background = true,
            sign = true,
        },
        above = 0,
        below = 0,
    },
    win_options = {
        conceallevel = {
            rendered = 3,
        },
    },
})
