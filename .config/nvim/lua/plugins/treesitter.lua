require('nvim-treesitter').setup {
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath('data') .. '/site',
    highlight = { enable = true }
}

require('nvim-treesitter').install { "bash", "c", "css", "cpp", "go", "html", "java",
    "javascript", "json", "lua", "markdown", "markdown_inline", "python", "rust", "tsx", "typescript" }

vim.api.nvim_create_autocmd('FileType', {
  desc = "Enable Treesitter for every supported filetype ",
  group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
  callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})
