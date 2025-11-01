-- Nvim-lspconfig: database of default language servers configs
-- easily available at: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
--
-- Mason: package manager for installing and managing language servers (and other tools)
--
-- Mason-lspconfig: bridge between nvim-lspconfgig and mason allowing to automatically install
-- and enable installed servers (auto-attach based on filetype)
--
-- LSP client (Nvim) capabilities can be extended by plugins like e.g. blink.cmp for completion.

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "clangd", "basedpyright" },
})

--vim.lsp.config( "lua_ls", {
--    settings = {
--        Lua = {
--            diagnostics = {
--                globals = { "vim" },
--                --undefined_global = false, -- remove this from diag!
--                --missing_parameters = false, -- missing fields :)
--            },
--        },
--    },
--})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(args)
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
        end

        ---@diagnostic disable-next-line: different-requires
        local fuzzy_finder = require('fzf-lua')

        -- Most of the functions below work on a word under cursor
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('grr', fuzzy_finder.lsp_references, '[G]oto [R]eferences')
        map('gri', fuzzy_finder.lsp_implementations, '[G]oto [I]mplementation')
        map('grd', fuzzy_finder.lsp_definitions, '[G]oto [D]efinition') -- press <C-t> to jump back
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gO', fuzzy_finder.lsp_document_symbols, 'Open Document Symbols')
        map('gW', fuzzy_finder.lsp_workspace_symbols, 'Open Workspace Symbols')
        map('grt', fuzzy_finder.lsp_typedefs, '[G]oto [T]ype Definition')

        -- Diagnostic keymaps
        map(']d', vim.diagnostic.goto_next, 'Goto next diagnostic')
        map('[d', vim.diagnostic.goto_prev, 'Goto prev diagnostic')
        map('[D', vim.diagnostic.goto_prev, 'Goto prev diagnostic')
        map(']D', vim.diagnostic.goto_prev, 'Goto prev diagnostic')
        map('<leader>de', vim.diagnostic.open_float, '[E]xpand diagnostic')
        map('<leader>dl', vim.diagnostic.setloclist, '[L]ocation list')
        map('<leader>q', vim.diagnostic.setqflist, '[Q]uickfix list')
        map('<leader>dd', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, 'Toggle diagnostics')

        -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
                return client:supports_method(method, bufnr)
            else
                return client.supports_method(method, { bufnr = bufnr })
            end
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, args.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = args.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = args.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
            })
        end

        -- The following code creates a keymap to toggle inlay hints in your
        -- code, if the language server you are using supports them
        --
        -- This may be unwanted, since they displace some of your code
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, args.buf) then
            map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = args.buf })
            end, '[T]oggle Inlay [H]ints')
        end
    end,
})

vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
    } or {},
    virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
        end,
    },
}

local capabilities = require('blink.cmp').get_lsp_capabilities()

local servers = {
    clangd = {
        cmd = {
            "clangd", --useful options: background-index, clang-tidy, header-insertion, query-driver
            "--background-index",
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                    --undefined_global = false, -- remove this from diag!
                    --missing_parameters = false, -- missing fields :)
                },
            },
        },

    },
}

for server_name, config in pairs(servers) do
    local server = servers[server_name] or {}
    -- Append additional capabilities returned by plugins instead of overwriting
    server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
    vim.lsp.config(server_name, config)
end
