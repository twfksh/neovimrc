if vim.loader then
    vim.loader.enable()
end

require('vim._core.ui2').enable {}

--[General Options] - nvim settings and behavior
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

--[Leader & Keymaps] - leader key and common mappings
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.keymap.set('n', ';', ':', {})
vim.keymap.set('n', '-', ':Ex<cr>', {})
vim.keymap.set('i', 'jk', '<Esc>', {})
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>', {})

--[Diagnostics] - diagnostic config and navigation
vim.diagnostic.config { virtual_lines = { only_current_line = true } }
vim.keymap.set('n', '<leader>e', function()
    vim.diagnostic.open_float(nil, { focus = false })
end, {})
vim.keymap.set('n', '[d', function()
    vim.diagnostic.jump { count = -1 }
end, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', function()
    vim.diagnostic.jump { count = 1 }
end, { desc = 'Next diagnostic' })

--[Plugin Declarations] - all plugin sources
vim.pack.add({
    'https://github.com/vague2k/vague.nvim',
    'https://github.com/sainnhe/gruvbox-material',
    'https://github.com/itchyny/lightline.vim',
    'https://github.com/chentoast/marks.nvim',
    'https://github.com/nvim-mini/mini.pairs',
    'https://github.com/nvim-mini/mini.indentscope',
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/folke/flash.nvim',
    'https://github.com/chomosuke/typst-preview.nvim',
    'https://codeberg.org/mfussenegger/nvim-dap',
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '^v1.*' },
    'https://github.com/ibhagwan/fzf-lua',
    'https://github.com/dmtrKovalenko/fff.nvim',
    { src = 'https://github.com/stevearc/conform.nvim' },
}, { confirm = false })

--[Theme] - colorscheme and highlight overrides
vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        vim.api.nvim_set_hl(0, '@lsp.type.number', { italic = true })
    end,
})

vim.cmd [[colorscheme vague]]

--[Editor] - lightweight plugin setups
require('marks').setup {}
require('mini.pairs').setup {}
require('mini.indentscope').setup {}

require('flash').setup {}
vim.keymap.set({ 'n', 'x', 'o' }, 's', require('flash').jump, { desc = 'flash' })
vim.keymap.set('c', '<c-s>', require('flash').toggle, { desc = 'toggle flash' })

--[Statusline] - lightline config and LSP status
function _G.lightline_filename_with_lsp()
    local ft = vim.bo.filetype
    if ft == '' then
        ft = 'unknown'
    end
    local clients = vim.lsp.get_clients { bufnr = 0 }
    local lsp_status = ''
    if next(clients) ~= nil then
        local names = {}
        for _, client in pairs(clients) do
            table.insert(names, client.name)
        end
        lsp_status = ' [' .. table.concat(names, ', ') .. ']'
    end
    return ft .. lsp_status
end

vim.g.lightline = {
    colorscheme = 'wombat',
    active = {
        left = {
            { 'mode', 'paste' },
            { 'readonly', 'filename', 'modified' },
        },
        right = {
            { 'lineinfo' },
            { 'percent' },
            { 'better_filetype', 'fileformat', 'fileencoding' },
        },
    },
    component_function = {
        better_filetype = 'v:lua.lightline_filename_with_lsp',
    },
}

--[Git] - gitsigns with deferred loading
vim.api.nvim_create_autocmd('BufReadPre', {
    once = true,
    callback = function()
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
    end,
})

--[DAP] - debugging keymaps
local dap = require 'dap'
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>dB', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
end, { desc = 'Conditional breakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Continue' })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step over' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step into' })
vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Step out' })
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Open REPL' })

--[LSP / Completion] - mason, lspconfig, blink.cmp
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method 'textDocument/definition' then
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
        end
        if client:supports_method 'textDocument/declaration' then
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = args.buf })
        end
        if client:supports_method 'textDocument/implementation' then
            vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { buffer = args.buf })
        end
        if client:supports_method 'textDocument/hover' then
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf })
        end
        if client:supports_method 'textDocument/references' then
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = args.buf })
        end
        if client:supports_method 'textDocument/rename' then
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = args.buf })
        end
        if client:supports_method 'textDocument/codeAction' then
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = args.buf })
        end
        if client.server_capabilities.documentFormattingProvider then
            vim.keymap.set('n', '<leader>bf', function()
                require('conform').format { lsp = 'fallback' }
            end, { buffer = args.buf, desc = 'Format buffer' })
        end
    end,
})

vim.api.nvim_create_autocmd('BufReadPre', {
    once = true,
    callback = function()
        local servers = {
            lua_ls = require 'lsp.lua_ls',
            tinymist = require 'lsp.tinymist',
            ts_ls = {},
            pyrefly = {},
            rust_analyzer = {},
            gopls = {},
        }
        require('mason').setup()
        require('mason-lspconfig').setup {
            ensure_installed = vim.tbl_keys(servers),
            handlers = {
                function(server_name)
                    local config = servers[server_name] or {}
                    require('lspconfig')[server_name].setup(config)
                end,
            },
        }
    end,
})

vim.api.nvim_create_autocmd('InsertEnter', {
    once = true,
    callback = function()
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
    end,
})

--[Formatting] - conform.nvim for async safe formatting
require('conform').setup {
    format_on_save = {
        timeout_ms = 500,
        lsp_format = 'fallback',
    },
    formatters_by_ft = {
        lua = { 'stylua' },
        zig = { 'zigfmt' },
        typescript = { 'prettierd', 'prettier' },
        typescriptreact = { 'prettierd', 'prettier' },
        javascript = { 'prettierd', 'prettier' },
        javascriptreact = { 'prettierd', 'prettier' },
        json = { 'prettierd', 'prettier' },
        yaml = { 'prettierd', 'prettier' },
    },
}

--[Fuzzy Finder] - fzf-lua and fff.nvim
-- fzf-lua: loaded lazily on first keymap use
local fzf_loaded = false
local function fzf_lazy(command)
    return function()
        if not fzf_loaded then
            fzf_loaded = true
            vim.cmd.packadd 'fzf-lua'
            require('fzf-lua').setup {
                winopts = {
                    border = 'single',
                    preview = {
                        border = 'single',
                    },
                },
            }
            require('fzf-lua').register_ui_select {}
        end
        vim.cmd('FzfLua ' .. command)
    end
end

vim.keymap.set('n', '<leader>f.', fzf_lazy 'buffers', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>lg', fzf_lazy 'lgrep_curbuf', { desc = 'Live Grep current buffer' })
vim.keymap.set('n', '<leader>fh', fzf_lazy 'helptags', { desc = 'Find helptags' })
vim.keymap.set('n', '<leader>fk', fzf_lazy 'keymaps', { desc = 'Find keymaps' })
vim.keymap.set('n', '<leader>fm', fzf_lazy 'marks', { desc = 'Find marks' })
vim.keymap.set('n', '<leader>fdd', fzf_lazy 'diagnostics_document', { desc = 'Find document diagnostics' })
vim.keymap.set('n', '<leader>fdw', fzf_lazy 'diagnostics_workspace', { desc = 'Find workspace diagnostics' })

-- fff.nvim
require('fff').setup {
    lazy_sync = true,
    layout = {
        prompt_position = 'top',
        height = 0.85,
        width = 0.8,
        preview_position = 'right',
        preview_size = 0.6,
        anchor = 'center',
    },
    prompt = '> ',
    hl = {
        normal = 'Normal',
    },
    keymaps = {
        move_up = { '<Up>', '<C-p>', '<C-k>' },
        move_down = { '<Down>', '<C-n>', '<C-j>' },
        preview_scroll_up = { '<C-u>', '<C-S-k>' },
        preview_scroll_down = { '<C-d>', '<C-S-j>' },
    },
}
vim.keymap.set('n', 'ff', require('fff').find_files, { desc = 'FFF: find files' })
vim.keymap.set('n', 'fg', require('fff').live_grep, { desc = 'FFF: live grep' })

vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
            if not ev.data.active then
                vim.cmd.packadd 'fff.nvim'
            end
            require('fff.download').download_or_build_binary()
        end
    end,
})

--[Built-in / Misc] - netrw, undotree, user commands
vim.g.netrw_banner = 0

vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_vimball = 1

vim.cmd [[packadd nvim.undotree]]
vim.keymap.set('n', '<leader>u', ':Undotree<cr>', {})

vim.api.nvim_create_user_command('PackClean', function()
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
end, {})

--[Autocmds] - general autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    pattern = '*.jsx,*.tsx',
    group = vim.api.nvim_create_augroup('TS', { clear = true }),
    callback = function()
        vim.cmd [[set filetype=typescriptreact]]
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'superhtml' },
    callback = function()
        vim.treesitter.start()
    end,
})
