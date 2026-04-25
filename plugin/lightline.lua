vim.pack.add { 'https://github.com/itchyny/lightline.vim' }

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
            { 'mode',     'paste' },
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
