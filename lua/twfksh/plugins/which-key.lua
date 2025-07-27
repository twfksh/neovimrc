return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VeryLazy', -- Sets the loading event to 'VimEnter'
  opts = {
    preset = 'helix',
    delay = 0,
    icons = {},
    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]est' },
      { '<leader>T', group = '[T]oggle' },
      -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    },
  },
}
