vim.loader.enable()
require('vim._core.ui2').enable {}

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.cmd [[set completeopt+=menuone,noselect,popup]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3
vim.opt.winborder = 'single'
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true

local undodir = vim.fn.stdpath 'data' .. '/undodir'
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, 'p')
end
vim.opt.undodir = undodir
vim.opt.undofile = true

vim.keymap.set('n', ';', ':', {})
vim.keymap.set('n', '-', ':Ex<cr>', {})
vim.keymap.set('i', 'jk', '<Esc>', {})
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>', {})

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

vim.pack.add { 'https://github.com/vague2k/vague.nvim' }

vim.api.nvim_create_autocmd('ColorScheme', {
    callback = function()
        vim.api.nvim_set_hl(0, '@lsp.type.number', { italic = true })
    end,
})

vim.cmd.colorscheme 'vague'

vim.pack.add {
    'https://github.com/nvim-mini/mini.nvim',
    'https://github.com/lewis6991/gitsigns.nvim',
    'https://github.com/chentoast/marks.nvim',
    'https://github.com/folke/flash.nvim',
}

local hipatterns = require 'mini.hipatterns'
hipatterns.setup {
    highlighters = {
        fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
        hack = { pattern = 'HACK', group = 'MiniHipatternsHack' },
        todo = { pattern = 'TODO', group = 'MiniHipatternsTodo' },
        note = { pattern = 'NOTE', group = 'MiniHipatternsNote' },
        hex_color = hipatterns.gen_highlighter.hex_color { priority = 2000 },
    },
}

require('mini.indentscope').setup {}

local statusline = require 'mini.statusline'
statusline.setup {}
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
    return '%2l:%-2v'
end
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_fileinfo = function()
    local ft = vim.bo.filetype ~= '' and vim.bo.filetype or 'unknown'
    local clients = vim.lsp.get_clients { bufnr = 0 }
    local lsp = ''
    if #clients > 0 then
        local names = {}
        for _, client in ipairs(clients) do
            table.insert(names, client.name)
        end
        lsp = ' [' .. table.concat(names, ', ') .. ']'
    end
    return ft .. lsp .. ' %{&fenc?&fenc:&enc} %{&ff}'
end

require('gitsigns').setup {
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    },
    current_line_blame = true,
    current_line_blame_opts = { delay = 250 },
}

require('marks').setup {}

require('flash').setup {}
vim.keymap.set({ 'n', 'x', 'o' }, 's', require('flash').jump, { desc = 'flash' })
vim.keymap.set('c', '<c-s>', require('flash').toggle, { desc = 'toggle flash' })

vim.pack.add {
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
}

local servers = {
    lua_ls = require 'lsp.lua_ls',
    tinymist = require 'lsp.tinymist',
    ts_ls = {},
    pyrefly = {},
    rust_analyzer = {},
    gopls = {},
    zls = {},
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

vim.pack.add { 'https://github.com/stevearc/conform.nvim' }

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
    formatters = {
        zigfmt = {
            command = 'zig',
            args = { 'fmt', '--stdin' },
            stdin = true,
        },
    },
    notify_on_error = false,
}

vim.pack.add {
    'https://github.com/saghen/blink.lib',
    'https://github.com/saghen/blink.cmp',
}

require('blink.cmp').setup {
    keymap = { preset = 'super-tab' },
}

vim.pack.add { 'https://github.com/ibhagwan/fzf-lua' }

require('fzf-lua').setup {
    winopts = {
        border = 'single',
        preview = { border = 'single' },
    },
}
require('fzf-lua').register_ui_select {}

vim.keymap.set('n', 'ff', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
vim.keymap.set('n', 'fg', '<cmd>FzfLua live_grep<cr>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>f.', '<cmd>FzfLua buffers<cr>', { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>lg', '<cmd>FzfLua lgrep_curbuf<cr>', { desc = 'Live Grep current buffer' })
vim.keymap.set('n', '<leader>fh', '<cmd>FzfLua helptags<cr>', { desc = 'Find helptags' })
vim.keymap.set('n', '<leader>fk', '<cmd>FzfLua keymaps<cr>', { desc = 'Find keymaps' })
vim.keymap.set('n', '<leader>fm', '<cmd>FzfLua marks<cr>', { desc = 'Find marks' })
vim.keymap.set('n', '<leader>fdd', '<cmd>FzfLua diagnostics_document<cr>', { desc = 'Find document diagnostics' })
vim.keymap.set('n', '<leader>fdw', '<cmd>FzfLua diagnostics_workspace<cr>', { desc = 'Find workspace diagnostics' })

vim.pack.add { 'https://codeberg.org/mfussenegger/nvim-dap' }

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

vim.pack.add { 'https://github.com/chomosuke/typst-preview.nvim' }

vim.g.netrw_banner = 0
vim.cmd [[packadd nvim.undotree]]
vim.keymap.set('n', '<leader>u', ':Undotree<cr>', {})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client.server_capabilities.documentFormattingProvider then
            vim.keymap.set('n', '<leader>bf', function()
                require('conform').format {
                    lsp_format = 'fallback',
                    async = true,
                    quiet = true,
                    stop_after_first = true,
                }
            end, { buffer = args.buf, desc = 'Format buffer' })
        end
    end,
})

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
