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
        keymap = { preset = 'inherit' },
    },
}
