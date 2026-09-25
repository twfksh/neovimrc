local M = {}

local function get_session_name()
	local cwd = vim.uv.cwd()
	if not cwd then
		return
	end

	cwd = vim.fs.normalize(vim.fn.fnamemodify(cwd, ":p"))
	return vim.fs.joinpath(vim.fn.stdpath("data"), "sessions", vim.fn.sha256(cwd) .. ".vim")
end

function M:name()
	return get_session_name()
end

function M:save()
	local path = self:name()
	if not path then
		vim.notify("Unable to determine the current working directory", vim.log.levels.ERROR)
		return
	end

	vim.fn.mkdir(vim.fs.dirname(path), "p")
	vim.cmd("mksession! " .. vim.fn.fnameescape(path))
	vim.notify("Session saved to " .. path)
end

function M:delete()
	local path = self:name()
	if not path then
		vim.notify("Unable to determine the current working directory", vim.log.levels.ERROR)
		return
	end

	if vim.fn.filereadable(path) == 0 then
		vim.notify("No session found", vim.log.levels.WARN)
		return
	end

	if vim.fn.delete(path) == 0 then
		vim.notify("Session deleted")
	else
		vim.notify("Unable to delete session", vim.log.levels.ERROR)
	end
end

local function source_local_session()
	if vim.g.local_session_loaded or vim.fn.argc() ~= 0 then
		return
	end

	local path = get_session_name()
	if path and vim.fn.filereadable(path) == 1 then
		vim.g.local_session_loaded = true
		vim.cmd.source(vim.fn.fnameescape(path))
		vim.cmd("filetype detect")
	end
end

function M:init()
	vim.api.nvim_create_autocmd("VimEnter", {
		group = vim.api.nvim_create_augroup("local_session_auto_source", { clear = true }),
		once = true,
		callback = source_local_session,
	})
end

return M
