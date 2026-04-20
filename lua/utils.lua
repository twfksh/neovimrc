---Utility function to create key bindings.
---@param lhs string
---@param rhs string|function
---@param opts string|table
---@param mode? string|string[]
---@param bufnr? integer
local function bind(lhs, rhs, opts, mode, bufnr)
    opts = type(opts) == 'string' and { desc = opts } or
        vim.tbl_extend('force', opts --[[@as table]], { buffer = bufnr })
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, opts)
end

---Clean up unused plugins.
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

return {
    bind = bind,
    pack_clean = pack_clean,
}
