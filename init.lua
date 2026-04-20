if vim.loader then
    vim.loader.enable()
end
require('vim._core.ui2').enable({})

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

local bind = require('utils').bind

bind(';', ':', {})
bind('-', ':Ex<cr>', {})
bind('jk', '<Esc>', {}, 'i')
bind('<Esc>', '<cmd>nohlsearch<cr>', {})

local gh = function(x) return 'https://github.com/' .. x end
local cb = function(x) return 'https://codeberg.org/' .. x end

vim.pack.add({
    gh('vague2k/vague.nvim'),
    gh('itchyny/lightline.vim'),
    gh('chentoast/marks.nvim'),
    gh('nvim-mini/mini.pairs'),
    gh('lewis6991/gitsigns.nvim'),
    -- gh('arborist-ts/arborist.nvim'),
    gh('neovim/nvim-lspconfig'),
    gh('mason-org/mason.nvim'),
    gh('mason-org/mason-lspconfig.nvim'),
    gh('WhoIsSethDaniel/mason-tool-installer.nvim'),
    { src = gh('saghen/blink.cmp'), version = vim.version.range '^v1.*' },
    gh('ibhagwan/fzf-lua'),
    gh('folke/flash.nvim'),
    gh('chomosuke/typst-preview.nvim'),
    cb('mfussenegger/nvim-dap'),
}, { confirm = false })

vim.cmd [[colorscheme vague]]
vim.g.lightline = { colorscheme = 'wombat' }

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

local lsp_servers = {
    lua_ls = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file('lua', true) } } },
}
require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup {
    ensure_installed = vim.tbl_keys(lsp_servers),
}
require('blink.cmp').setup({
    keymap = { preset = 'super-tab' },
    appearance = {
        nerd_font_variant = 'mono'
    },
    completion = {
        documentation = { auto_show = false }
    },
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
})

require('fzf-lua').setup {
    winopts = {
        border = 'single',
        preview = {
            border = 'single',
        },
    },
}
require('fzf-lua').register_ui_select {}

bind('<leader>ff', ':FzfLua files<cr>', {})
bind('<leader>f.', ':FzfLua buffers<cr>', {})
bind('<leader>frg', ':FzfLua grep_curbuf<cr>', {})
bind('<leader>fg', ':FzfLua lgrep_curbuf<cr>', {})
bind('<leader>fm', ':FzfLua marks<cr>', {})
bind('<leader>fdd', ':FzfLua diagnostics_document<cr>', {})
bind('<leader>fdw', ':FzfLua diagnostics_workspace<cr>', {})

vim.diagnostic.config { virtual_text = false }
bind('<leader>e', function() vim.diagnostic.open_float(nil, { focus = false }) end, {})

require('flash').setup {}
bind('s', function() require('flash').jump() end, { desc = 'flash' }, { 'n', 'x', 'o' })
bind('<c-s>', function() require('flash').toggle() end, { desc = 'toggle flash' }, 'c')
