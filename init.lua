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

vim.g.mapleader = ' '

vim.pack.add {
    { src = 'https://github.com/vague2k/vague.nvim' },
    { src = 'https://github.com/itchyny/lightline.vim' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/chentoast/marks.nvim' },
    { src = 'https://github.com/chomosuke/typst-preview.nvim' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/folke/flash.nvim' },
}

vim.cmd [[colorscheme vague]]
vim.g.lightline = { colorscheme = 'wombat' }

-- [[ LSP Setup ]] --
require('mason').setup {}
require('mason-lspconfig').setup {}
require('mason-tool-installer').setup {
    ensure_installed = { 'lua_ls', 'stylua', 'tinymist', 'clangd', 'gopls', 'zls', 'vtsls' },
}

vim.lsp.enable {
    'lua_ls',
    'cssls',
    'tinymist',
    'rust_analyzer',
    'clangd',
    'ruff',
    'glsl_analyzer',
    'hlint',
    'tailwindcss',
    'vtsls',
    'zls',
}

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method 'textDocument/completion' then
            -- Optional: trigger autocompletion on EVERY keypress. May be slow!
            local chars = {}
            for i = 32, 126 do
                table.insert(chars, string.char(i))
            end
            client.server_capabilities.completionProvider.triggerCharacters = chars
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end
    end,
})

vim.cmd [[set completeopt+=menuone,noselect,popup]]

require('conform').setup {
    format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
    },
    formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        rust = { 'rustfmt' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
    },
}

require('fzf-lua').setup {
    winopts = {
        border = 'single',
        preview = {
            border = 'single',
        },
    },
}

require('gitsigns').setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
}

require('marks').setup {}
require('flash').setup {}

local ft_group = vim.api.nvim_create_augroup('FileTypeSetup', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'markdown', 'lua', 'rust', 'typst', 'typescript', 'javascript', 'c', 'cpp', 'python', 'zig', 'go' },
    group = ft_group,
    callback = function()
        vim.treesitter.start()
    end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*.jsx,*.tsx',
    group = vim.api.nvim_create_augroup('TS', { clear = true }),
    callback = function()
        vim.cmd [[set filetype=typescriptreact]]
    end,
})

-- stylua: ignore
local function keymap(keymaps)
    for _, _keymap in ipairs(keymaps) do
        vim.keymap.set(_keymap.mode, _keymap.key, _keymap.fn, { desc = _keymap.desc })
    end
end

-- stylua: ignore
keymap({
    { key = "zk",    mode = { "n", "x", "o" }, fn = function() require('flash').jump() end,              desc = "Flash" },
    { key = "Zk",    mode = { "n", "x", "o" }, fn = function() require('flash').treesitter() end,        desc = "Flash Treesitter" },
    { key = "r",     mode = "o",               fn = function() require('flash').remote() end,            desc = "Remote Flash" },
    { key = "R",     mode = { "o", "x" },      fn = function() require('flash').treesitter_search() end, desc = "Treesitter Search" },
    { key = "<c-s>", mode = "c",               fn = function() require('flash').toggle() end,            desc = "Toggle Flash Search" },
})

vim.keymap.set('n', ';', ':')
vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '-', ':Ex<cr>')
vim.keymap.set('n', '<leader>ff', ':FzfLua files<cr>')
vim.keymap.set('n', '<leader>f.', ':FzfLua buffers<cr>')
vim.keymap.set('n', '<leader>fg', ':FzfLua grep<cr>')
vim.keymap.set('n', '<leader>fm', ':FzfLua marks<cr>')

local function pack_clean()
    local unused = {}
    for _, plugin in ipairs(vim.pack.get()) do
        if not plugin.active then
            table.insert(unused, plugin.spec.name)
        end
    end
    if #unused == 0 then
        print 'No unused plugins.'
        return
    end
    if vim.fn.confirm('Remove unused plugins?', '&Yes\n&No', 2) == 1 then
        vim.pack.del(unused)
    end
end
vim.keymap.set('n', '<leader>pc', pack_clean)
