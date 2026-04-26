local M = {}

---Utility function to create key bindings.
---@param lhs string
---@param rhs string|function
---@param opts string|table
---@param mode? string|string[]
---@param bufnr? integer
function M.bind(lhs, rhs, opts, mode, bufnr)
    opts = type(opts) == 'string' and { desc = opts } or vim.tbl_extend('force', opts --[[@as table]], { buffer = bufnr })
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, opts)
end

---Clean up unused plugins.
function M.pack_clean()
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

-- For local plugin development - to be used with vim.pack.add()
function M.prefer_local(local_path, remote_src)
    local expanded = vim.fs.normalize(vim.fn.expand(local_path))
    if vim.uv.fs_stat(expanded) then
        return expanded
    end
    return remote_src
end

-- Custom deep merge that appends lists
-- (instead of replacing them like vim.tbl_deep_extend does)
-- and recurses into dicts
function M.merge(base, override)
    for k, v in pairs(override) do
        if v == vim.NIL then
            base[k] = nil
        elseif type(v) == 'table' then
            local bv = base[k]
            if type(bv) ~= 'table' then
                base[k] = v
            elseif vim.islist(v) then
                for _, item in ipairs(v) do
                    if type(item) == 'table' or not vim.list_contains(bv, item) then
                        table.insert(bv, item)
                    end
                end
            else
                M.merge(bv, v)
            end
        else
            base[k] = v
        end
    end
    return base
end

return M
