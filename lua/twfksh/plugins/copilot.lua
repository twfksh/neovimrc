return {
  'github/copilot.vim',
  config = function()
    -- vim.g.copilot_no_tab_map = true
    vim.g.copilot_filetypes = {
      ['*'] = false,
      ['javascript'] = true,
      ['typescript'] = true,
      ['python'] = true,
      ['lua'] = true,
      ['html'] = true,
      ['css'] = true,
      ['markdown'] = true,
    }
    -- vim.keymap.set('i', '<C-J>', 'copilot#Accept("<CR>")', { expr = true, silent = true })
  end,
}
