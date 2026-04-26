if vim.loader then
    vim.loader.enable()
end

require('vim._core.ui2').enable {}

local bind = require('helpers').bind
local lazyload = require 'lazyload'

vim.api.nvim_set_hl(0, '@lsp.type.number', { italic = true })
vim.cmd [[set completeopt+=menuone,noselect,popup]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3
vim.opt.termguicolors = true
vim.opt.winborder = 'single'
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
local undodir = vim.fn.stdpath 'data' .. '/undodir'
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, 'p')
end
vim.opt.undodir = undodir
vim.opt.undofile = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

bind(';', ':', {})
bind('-', ':Ex<cr>', {})
bind('jk', '<Esc>', {}, 'i')
bind('<Esc>', '<cmd>nohlsearch<cr>', {})

vim.diagnostic.config { virtual_text = false }
bind('<leader>e', function()
    vim.diagnostic.open_float(nil, { focus = false })
end, {})

vim.pack.add({
    'https://github.com/vague2k/vague.nvim',
    'https://github.com/itchyny/lightline.vim',
    'https://github.com/chentoast/marks.nvim',
    'https://github.com/nvim-mini/mini.pairs',
    'https://github.com/lewis6991/gitsigns.nvim',
    -- 'https://github.com/arborist-ts/arborist.nvim',
    'https://github.com/folke/flash.nvim',
    'https://github.com/chomosuke/typst-preview.nvim',
    'https://codeberg.org/mfussenegger/nvim-dap',
}, { confirm = false })

-- require('vague').setup { transparent = true }
vim.cmd [[colorscheme vague]]

require('marks').setup {}
require('mini.pairs').setup {}

require('gitsigns').setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 250,
    },
}

lazyload.on_event({ 'BufReadPre', 'BufNewFile' }, function()
    vim.pack.add {
        { src = 'https://github.com/neovim/nvim-lspconfig' },
        { src = 'https://github.com/mason-org/mason.nvim' },
        { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
        { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
    }

    local lsp_servers = {
        lua_ls = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file('lua', true) } } },
    }
    require('mason').setup()
    require('mason-lspconfig').setup()
    require('mason-tool-installer').setup {
        ensure_installed = vim.tbl_keys(lsp_servers),
    }
end)

lazyload.on_event('InsertEnter', function()
    vim.pack.add { { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '^v1.*' } }
    require('blink.cmp').setup {
        keymap = { preset = 'super-tab' },
        appearance = {
            nerd_font_variant = 'mono',
        },
        completion = {
            documentation = { auto_show = false },
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
    }
end)

lazyload.on_vim_enter(function()
    vim.pack.add { 'https://github.com/ibhagwan/fzf-lua' }
    require('fzf-lua').setup {
        winopts = {
            border = 'single',
            preview = {
                border = 'single',
            },
        },
    }
    require('fzf-lua').register_ui_select {}

    bind('<leader>ff', ':FzfLua files<cr>', { desc = 'Find files' })
    bind('<leader>f.', ':FzfLua buffers<cr>', { desc = 'Find buffers' })
    bind('<leader>lg', ':FzfLua lgrep_curbuf<cr>', { desc = 'Live Grep current buffer' })
    bind('<leader>gp', ':FzfLua grep_project<cr>', { desc = 'Grep project' })
    bind('<leader>fh', ':FzfLua helptags<cr>', { desc = 'Find helptags' })
    bind('<leader>fk', ':FzfLua keymaps<cr>', { desc = 'Find keymaps' })
    bind('<leader>fm', ':FzfLua marks<cr>', { desc = 'Find marks' })
    bind('<leader>fdd', ':FzfLua diagnostics_document<cr>', { desc = 'Find document diagnostics' })
    bind('<leader>fdw', ':FzfLua diagnostics_workspace<cr>', { desc = 'Find workspace diagnostics' })
end)

require('flash').setup {}
bind('s', require('flash').jump, { desc = 'flash' }, { 'n', 'x', 'o' })
bind('<c-s>', require('flash').toggle, { desc = 'toggle flash' }, 'c')
