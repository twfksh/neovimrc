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
