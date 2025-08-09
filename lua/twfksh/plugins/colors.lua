return {
  {
    'maxmx03/solarized.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      vim.o.termguicolors = true
      vim.o.background = 'dark'
      require('solarized').setup(opts)
      -- vim.cmd.colorscheme 'solarized'
    end,
  },
  { 'EdenEast/nightfox.nvim', lazy = false, priority = 1000 },
  { 'folke/tokyonight.nvim', lazy = false, priority = 1000, opts = {} },
  { 'navarasu/onedark.nvim', lazy = false, priority = 1000, opts = {} },
  { 'lunarvim/darkplus.nvim', lazy = false, priority = 1000, opts = {} },
  { 'bluz71/vim-nightfly-colors', name = 'nightfly', lazy = false, priority = 1000 },
}
