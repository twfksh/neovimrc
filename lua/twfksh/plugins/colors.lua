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
  { 'rebelot/kanagawa.nvim', lazy = false, priority = 1000 },
  {
    'zenbones-theme/zenbones.nvim',
    dependencies = 'rktjmp/lush.nvim',
    lazy = false,
    priority = 1000,
    -- config = function()
    --     vim.g.zenbones_darken_comments = 45
    --     vim.cmd.colorscheme('zenbones')
    -- end
  },
  {
    'vague-theme/vague.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      -- NOTE: you do not need to call setup if you don't want to.
      require('vague').setup {}
      -- vim.cmd 'colorscheme vague'
    end,
  },
  { 'rose-pine/neovim', name = 'rose-pine' },
  { 'sainnhe/gruvbox-material' },
  { 'sainnhe/everforest' },
}
