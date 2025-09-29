require("blink.cmp").setup{
    --enabled = function() return not vim.tbl_contains({ "markdown" }, vim.bo.filetype) end,
    keymap = {
        ['<Esc>'] = { 'hide', 'fallback' },
        ['<Enter>'] = { 'select_and_accept', 'fallback' },
        ['<Right>'] = { 'select_and_accept', 'fallback' },
    },
    completion = {
        menu = {
            auto_show = false,
        },
    },
    cmdline = {
        enabled = true,
        keymap = {
            preset = 'cmdline' ,
            ['<Tab>'] = { 'show', 'select_next' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Right>'] = { 'select_and_accept', 'fallback' },
            ['<Left>'] = { 'cancel', 'fallback' },
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
        sources = { 'cmdline' },
    },
}
