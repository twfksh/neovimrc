local bind = require('utils').bind

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*.jsx,*.tsx',
    group = vim.api.nvim_create_augroup('TS', { clear = true }),
    callback = function()
        vim.cmd [[set filetype=typescriptreact]]
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'superhtml' },
    callback = function()
        vim.treesitter.start()
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method 'textDocument/definition' then
            bind('gd', vim.lsp.buf.definition, {})
        end
        if client:supports_method 'textDocument/declaration' then
            bind('gD', vim.lsp.buf.declaration, {})
        end
        if client:supports_method 'textDocument/implementation' then
            bind('gI', vim.lsp.buf.implementation, {})
        end
        -- Auto-format ("lint") on save.
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method 'textDocument/willSaveWaitUntil' and client:supports_method 'textDocument/formatting' then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format { bufnr = args.buf, id = client.id, timeout_ms = 1000 }
                end,
            })
        end
    end,
})
