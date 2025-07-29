vim.loader.enable()

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  require 'twfksh.plugins.guess-indent',
  require 'twfksh.plugins.todo-comments',
  require 'twfksh.plugins.flash',
  require 'twfksh.plugins.smear-cursor',

  require 'twfksh.plugins.gitsigns',
  require 'twfksh.plugins.which-key',
  require 'twfksh.plugins.telescope',
  require 'twfksh.plugins.lspconfig',
  require 'twfksh.plugins.copilot',

  require 'twfksh.plugins.colors',

  require 'twfksh.plugins.mini',
  require 'twfksh.plugins.lualine',
  require 'twfksh.plugins.treesitter',
  require 'twfksh.plugins.better-escape',

  require 'twfksh.plugins.autopairs',

  require 'twfksh.plugins.debugger',
  require 'twfksh.plugins.vim-test',
  -- require 'twfksh.plugins.linter',

  require 'twfksh.plugins.uv',

  require 'twfksh.plugins.markview',
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
