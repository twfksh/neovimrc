local bind = require('helpers').bind

-- netrw config
vim.g.netrw_banner = 0

-- disable builtins
vim.g.loaded_2html_plugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimballPlugin = 1

vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_vimball = 1

-- native undotree
vim.cmd [[packadd nvim.undotree]]
bind('<leader>u', ':Undotree<cr>', {})
