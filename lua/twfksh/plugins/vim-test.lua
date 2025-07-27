return {
  'vim-test/vim-test',
  event = 'VeryLazy',
  config = function()
    vim.g['test#strategy'] = 'neovim'
    vim.g['test#neovim#term_position'] = 'vertical'

    vim.keymap.set('n', '<leader>tn', '<cmd>TestNearest<cr>', { desc = 'Test code (nearest)' })
    vim.keymap.set('n', '<leader>tf', '<cmd>TestFile<cr>', { desc = 'Test code (file)' })
    vim.keymap.set('n', '<leader>ts', '<cmd>TestSuite<cr>', { desc = 'Test code (suite)' })
    vim.keymap.set('n', '<leader>tl', '<cmd>TestLast<cr>', { desc = 'Test code (last)' })
  end,
}
