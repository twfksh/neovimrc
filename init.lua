vim.cmd [[set mouse=]]
vim.cmd [[set noswapfile]]
vim.cmd [[syntax on]]
vim.cmd [[filetype plugin indent on]]
vim.cmd [[hi @lsp.type.number gui=italic]]
vim.cmd [[set completeopt+=menuone,noselect,popup]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.winborder = 'single'
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'

vim.g.mapleader = " "

vim.pack.add({
    { src = 'https://github.com/vague2k/vague.nvim' },
    { src = 'https://github.com/itchyny/lightline.vim' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter',        version = 'main' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/chentoast/marks.nvim' },
    { src = 'https://github.com/chomosuke/typst-preview.nvim' },
})

vim.cmd [[colorscheme vague]]
vim.g.lightline = { colorscheme = 'wombat' }

-- [[ LSP Setup ]] --
require('mason').setup({})
require('mason-lspconfig').setup({})
require('mason-tool-installer').setup({
    ensure_installed = { 'lua_ls', 'stylua', 'tinymist', 'clangd', 'gopls', 'zls', 'vtsls' }
})

vim.lsp.enable({
    "lua_ls", "cssls", "tinymist",
	"rust_analyzer", "clangd", "ruff",
	"glsl_analyzer", "hlint",
	"tailwindcss", "vtsls", "zls"
})

require('marks').setup({})

require('fzf-lua').setup({
    winopts = {
        border = "single",
        preview = {
            border = "single",
        },
    },
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'markdown', 'lua', 'rust', 'typst', 'typescript', 'javascript', 'c', 'cpp', 'python', 'zig', 'go' },
	callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.jsx,*.tsx",
	group = vim.api.nvim_create_augroup("TS", { clear = true }),
	callback = function()
		vim.cmd([[set filetype=typescriptreact]])
	end
})

vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '-', ':Ex<cr>')
vim.keymap.set('n', '<leader>ff', ':FzfLua files<cr>')
vim.keymap.set('n', '<leader>f.', ':FzfLua buffers<cr>')
vim.keymap.set('n', '<leader>fg', ':FzfLua grep<cr>')
vim.keymap.set('n', '<leader>fm', ':FzfLua marks<cr>')
