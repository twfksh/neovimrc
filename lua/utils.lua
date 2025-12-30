---Utility for keymap creation.
---@param lhs string
---@param rhs string|function
---@param opts string|table
---@param mode? string|string[]
---@param bufnr? integer
local function keymap(lhs, rhs, opts, mode, bufnr)
    opts = type(opts) == 'string' and { desc = opts } or vim.tbl_extend('force', opts --[[@as table]], { buffer = bufnr })
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, opts)
end

return {
    keymap = keymap,
}
