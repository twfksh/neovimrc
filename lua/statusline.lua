local M = {}

local modes = {
	n = { "NORMAL", "Normal" }, no = { "NORMAL", "Normal" },
	i = { "INSERT", "Insert" }, ic = { "INSERT", "Insert" }, ix = { "INSERT", "Insert" },
	v = { "VISUAL", "Visual" }, V = { "V-LINE", "Visual" }, ["\22"] = { "V-BLOCK", "Visual" },
	s = { "SELECT", "Visual" }, S = { "S-LINE", "Visual" }, ["\19"] = { "S-BLOCK", "Visual" },
	R = { "REPLACE", "Replace" }, Rc = { "REPLACE", "Replace" },
	Rv = { "V-REPLACE", "Replace" }, Rx = { "REPLACE", "Replace" },
	c = { "COMMAND", "Command" }, cv = { "EX", "Command" }, ce = { "EX", "Command" },
	r = { "PROMPT", "Prompt" }, ["!"] = { "SHELL", "Shell" }, t = { "TERMINAL", "Terminal" },
}

function M.setup()
	for name, target in pairs({
		Normal = "Identifier", Insert = "String", Visual = "Statement", Replace = "ErrorMsg",
		Command = "Question", Prompt = "MoreMsg", Shell = "WarningMsg", Terminal = "Directory",
	}) do
		vim.api.nvim_set_hl(0, "Stl" .. name, { link = target })
	end
end

function M.mode_name()
	local mode = modes[vim.fn.mode(1)] or { vim.fn.mode(1), "Normal" }
	return ("%%#Stl%s#%s%%*"):format(mode[2], mode[1])
end

return M
