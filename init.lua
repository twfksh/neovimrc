vim.cmd([[set mouse=]])
vim.cmd([[set noswapfile]])
vim.cmd([[hi @lsp.type.number gui=bold]])
vim.opt.winborder = "single"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.showtabline = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.cursorcolumn = false
vim.opt.cursorline = true
-- vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.cmd("filetype plugin indent on")

vim.opt.statusline = " %{%v:lua.require('statusline').mode_name()%} %<%f %h%m%r%=%-14.(%l,%c%V%) %P "
vim.opt.laststatus = 3

vim.g.mapleader = " "

local map = vim.keymap.set

require("session"):init()


vim.pack.add({
	{ src = "https://github.com/sainnhe/everforest" },
	{ src = "https://github.com/chentoast/marks.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",            version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/hat0uma/csvview.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
	{ src = "https://github.com/julianolf/nvim-dap-lldb" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp", version = "main" },
})

require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		["<C-e>"] = false,
	},
	snippets = { preset = "luasnip" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "lua" },
})


vim.api.nvim_create_autocmd("FileType", {
	pattern = "typst",
	once = true,
	callback = function()
		require("typst-preview").setup()
	end,
})

require("csvview").setup({
	parser = {
		comments = { "#", "//" },
	},
	keymaps = {
		textobject_field_inner = { "if", mode = { "o", "x" } },
		textobject_field_outer = { "af", mode = { "o", "x" } },
		jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
		jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
		jump_next_row = { "<Enter>", mode = { "n", "v" } },
		jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "csv", "tsv" },
	group = vim.api.nvim_create_augroup("csvview_auto_enable", { clear = true }),
	callback = function(args)
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(args.buf) then
				vim.cmd.CsvViewEnable()
			end
		end)
	end,
})

require("dap-lldb").setup()
local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

require "marks".setup {
	builtin_marks = { "<", ">", "^" },
}

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'svelte', 'markdown', 'lua', 'odin', 'rust', 'typst',
		'typescript', 'javascript', 'c', 'cpp', 'glsl', 'zig', 'python',
		"typescriptreact", "react", },
	callback = function(args)
		if vim.bo[args.buf].buftype ~= "" or not vim.bo[args.buf].buflisted then
			return
		end

		pcall(vim.treesitter.start, args.buf)
	end,
})


require "mason".setup()
vim.lsp.config("lua_ls", require("lsp.lua_ls"))
vim.lsp.config("tinymist", require("lsp.tinymist"))
vim.lsp.config("ocamllsp", { cmd = { "opam", "exec", "--", "ocamllsp" } })
vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

local default_color = "everforest"

require("fzf-lua").setup {
	winopts = {
		fullscreen = true,
		border = "single",
		preview = {
			border = "border-sharp",
		},
	},
}

vim.lsp.enable({
	"lua_ls", "cssls", "svelte", "tinymist",
	"tclint",
	"rust_analyzer", "clangd", "ruff",
	"ocamllsp",
	"glsl_analyzer", "haskell-language-server", "hlint",
	"intelephense", "tailwindcss", "ts_ls",
	"emmet_language_server", "emmet_ls", "solargraph", "zls", "pyright"
})

require("oil").setup({
	lsp_file_methods = {
		enabled = true,
		timeout_ms = 1000,
		autosave_changes = true,
	},
	columns = {
		"icon",
	},
	float = {
		max_width = 0.3,
		max_height = 0.6,
		border = "single",
	},
})

vim.o.background = "dark"
vim.g.everforest_background = "medium"
vim.g.everforest_transparent_background = 2
vim.g.everforest_better_performance = 1
vim.g.everforest_enable_italic = 1
vim.cmd.colorscheme(default_color)
for _, name in ipairs({ "NormalFloat", "FloatBorder", "Pmenu" }) do
	local highlight = vim.api.nvim_get_hl(0, { name = name, link = false })
	highlight.bg = nil
	highlight.ctermbg = nil
	highlight.blend = nil
	vim.api.nvim_set_hl(0, name, highlight --[[@as vim.api.keyset.highlight]])
end
require("statusline").setup()
require("luasnip").setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

map("n", "<leader>pc", pack_clean)
local ls = require("luasnip")
local fzf = require("fzf-lua")


local function open_current_html()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		vim.notify("Preview requires a saved HTML file", vim.log.levels.ERROR)
		return
	end

	vim.cmd.update()

	local result = vim.system({ "xdg-open", path }, { text = true }):wait()
	if result.code ~= 0 then
		local output = result.stderr ~= "" and result.stderr or result.stdout
		if output == "" then
			output = "Failed to open " .. path
		end
		vim.notify(output or "<empty>", vim.log.levels.ERROR)
	end
end

local function preview_current_file()
	local filetype = vim.bo.filetype
	if filetype == "typst" then
		vim.cmd.TypstPreviewToggle()
	elseif filetype == "html" then
		open_current_html()
	else
		vim.notify("No preview action configured for filetype: " .. filetype, vim.log.levels.WARN)
	end
end

map({ "n", "x" }, "<leader>y", '"+y')
-- map({ "n", "x" }, "<leader>d", '"+d')
map({ "i", "s" }, "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })
map({ "n", "t" }, "<leader>t", "<Cmd>split<CR> <Cmd>term<CR>i")
map({ "n", "t" }, "<leader>x", "<Cmd>tabclose<CR>")
map("n", "<C-c>", "<Cmd>qa!<CR>", { desc = "Quit Neovim" })

vim.cmd([[
	nnoremap g= g+| " g=g=g= is less awkward than g+g+g+
	nnoremap gK @='ddkPJ'<cr>| " join lines but reversed. `@=` so [count] works
	xnoremap gK <esc><cmd>keeppatterns '<,'>-global/$/normal! ddpkJ<cr>
	noremap! <c-r><c-d> <c-r>=strftime('%F')<cr>
	noremap! <c-r><c-t> <c-r>=strftime('%T')<cr>
	noremap! <c-r><c-f> <c-r>=expand('%:t')<cr>
	noremap! <c-r><c-p> <c-r>=expand('%:p')<cr>
	xnoremap <expr> . "<esc><cmd>'<,'>normal! ".v:count1.'.<cr>'
]])


for i = 1, 8 do
	map({ "n", "t" }, "<leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

local opts = { noremap = true, silent = true }
map("n", "yag", ":%y<CR>", opts)
map("n", "vag", "ggVG", opts)
map("n", "<leader>m", "<Cmd>make<CR>", opts)
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)
map("n", "<ESC>", ":nohlsearch<CR>", opts)
map("n", "gl", "$", { desc = "Jump: End of line" })

map({ "n", "v", "x" }, ";", ":", { desc = "Self explanatory" })

map({ "n", "v", "x" }, "<leader>r", ":edit!<CR>", { desc = "Reload current file" })
map({ "n", "v", "x" }, "<leader>v", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>z", "<Cmd>e ~/.config/zsh/.zshrc<CR>", { desc = "Edit .zshrc" })
map({ "n", "v", "x" }, "<leader>n", ":norm ", { desc = "ENTER NORM COMMAND." })
map({ "n", "v", "x" }, "<leader>o", "<Cmd>source %<CR>", { desc = "Source " .. vim.fn.expand("$MYVIMRC") })
map({ "n", "v", "x" }, "<leader>O", "<Cmd>restart<CR>", { desc = "Restart vim." })
map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })
map({ "n", "v", "x" }, "<leader>i", [[<Cmd>tabedit .gitignore<CR>]], { desc = "Enter substitue mode in selection" })
map({ "n", "v", "x" }, "<leader>lf", vim.lsp.buf.format, { desc = "Format current buffer" })
map({ "v", "x", "n" }, "<C-y>", '"+y', { desc = "System clipboard yank." })

map({ "n" }, "<leader>p", preview_current_file, { desc = "Preview current file" })

map("n", "<leader>ss", function() require("session"):save() end, { desc = "Save session" })
map("n", "<leader>sd", function() require("session"):delete() end, { desc = "Delete session" })

map({ "n" }, "<leader>ff", fzf.files, { desc = "Find files" })
map({ "n" }, "<leader>fl", fzf.live_grep)
map({ "n" }, "<leader>fo", fzf.oldfiles)
map({ "n" }, "<leader>fb", fzf.buffers)
map({ "n" }, "<leader>fh", fzf.help_tags)
map({ "n" }, "<leader>fm", fzf.marks)
map({ "n" }, "<leader>fM", fzf.manpages)
map({ "n" }, "<leader>fg", function() fzf.files({ no_ignore = true }) end)
map({ "n" }, "<leader>fc", fzf.git_commits)
map({ "n" }, "<leader>fr", fzf.lsp_references)
map({ "n" }, "<leader>fd", fzf.diagnostics_document)
map({ "n" }, "<leader>ft", fzf.lsp_typedefs)
map({ "n" }, "<leader>f.", fzf.builtin)
map({ "n" }, "<leader>fk", fzf.keymaps)
map({ "n" }, "<leader>ca", fzf.lsp_code_actions, { desc = "LSP code actions" })

map({ "n" }, "<M-n>", "<cmd>resize +2<CR>")
map({ "n" }, "<M-e>", "<cmd>resize -2<CR>")
map({ "n" }, "<M-i>", "<cmd>vertical resize +5<CR>")
map({ "n" }, "<M-m>", "<cmd>vertical resize -5<CR>")

map({ "n" }, "-", "<cmd>Oil<CR>")
map({ "n" }, "<leader>c", "1z=")
map({ "n" }, "<C-q>", ":copen<CR>", { silent = true })
map({ "n" }, "<C-f>", "<Cmd>silent !xdg-open .<CR>", { desc = "Open current directory in Finder." })
map({ "n" }, "<leader>a", ":edit #<CR>", { desc = "Switch to the alternate buffer" })

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*.jsx,*.tsx",
	group = vim.api.nvim_create_augroup("TS", { clear = true }),
	callback = function()
		vim.cmd([[set filetype=typescriptreact]])
	end
})
