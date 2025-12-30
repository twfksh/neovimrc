if vim.loader then
    vim.loader.enable()
end

vim.cmd [[set mouse=]]
vim.cmd [[set noswapfile]]
vim.cmd [[syntax on]]
vim.cmd [[filetype plugin indent on]]
vim.cmd [[hi @lsp.type.number gui=italic]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = 'single'
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath 'data' .. '/undodir'
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.g.mapleader = ' '

vim.pack.add({
    'https://github.com/vague2k/vague.nvim',
    'https://github.com/itchyny/lightline.vim',
    'https://github.com/chentoast/marks.nvim',
    'https://github.com/nvim-mini/mini.pairs',
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    'https://github.com/saghen/blink.cmp',
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/folke/flash.nvim',
    'https://github.com/chomosuke/typst-preview.nvim',
    'https://github.com/dstein64/vim-startuptime',
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

require('nvim-treesitter').install { 'all' }

local lsp_servers = {
    lua_ls = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file('lua', true) } } },
}

---Utility for keymap creation.
---@param lhs string
---@param rhs string|function
---@param opts string|table
---@param mode? string|string[]
---@param bufnr? integer
local function keymap(lhs, rhs, opts, mode, bufnr)
    opts = type(opts) == 'string' and { desc = opts } or vim.tbl_extend('error', opts --[[@as table]], { buffer = bufnr })
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, opts)
end

require('fzf-lua').setup {
    winopts = {
        border = 'single',
        preview = {
            border = 'single',
        },
    },
}

keymap('<leader>ff', ':FzfLua files<cr>', {})
keymap('<leader>f.', ':FzfLua buffers<cr>', {})
keymap('<leader>fg', ':FzfLua grep<cr>', {})
keymap('<leader>fm', ':FzfLua marks<cr>', {})

require('mason').setup()
require('mason-lspconfig').setup()
require('mason-tool-installer').setup {
    ensure_installed = vim.tbl_keys(lsp_servers),
}

for server, config in pairs(lsp_servers) do
    vim.lsp.config(server, {
        settings = config,

        on_attach = function(_, bufnr)
            keymap('gA', ':FzfLua lsp_code_actions<cr>', { silent = true }, 'n', bufnr)
            keymap('gd', ':FzfLua lsp_definitions<cr>', {}, 'n', bufnr)
        end,
    })
end

vim.cmd [[set completeopt+=menuone,noselect,popup]]
require('blink.cmp').setup { fuzzy = { implementation = 'lua' } }

require('conform').setup {
    format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
    },
    formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'ruff', 'isort', 'black' },
        rust = { 'rustfmt' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
    },
}

vim.diagnostic.config {
    virtual_text = false,
}

keymap('<leader>e', function()
    vim.diagnostic.open_float(nil, { focus = false })
end, {})

require('flash').setup {}
keymap('s', function()
    require('flash').jump()
end, { desc = 'flash' }, { 'n', 'x', 'o' })
keymap('<c-s>', function()
    require('flash').toggle()
end, { desc = 'toggle flash' }, 'c')

keymap(';', ':', {})
keymap('jk', '<Esc>', {}, 'i')
keymap('-', ':Ex<cr>', {})
keymap('<Esc>', ':nohlsearch<cr>', {})
