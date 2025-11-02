return {
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
  lazy = false,
  config = function()
    require('oil').setup()
    vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { desc = 'Open parent directory in Oil' })
  end,
}
