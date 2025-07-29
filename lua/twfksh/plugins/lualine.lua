return {
  'nvim-lualine/lualine.nvim',
  -- dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  opts = {},
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = {
          {
            function()
              -- Filetype with LSP
              local filetype = vim.bo.filetype
              local clients = vim.lsp.get_clients { bufnr = 0 }
              local ft_part = filetype
              if next(clients) ~= nil then
                local client_names = {}
                for _, client in pairs(clients) do
                  table.insert(client_names, client.name)
                end
                ft_part = filetype .. '[' .. table.concat(client_names, ',') .. ']'
              end

              -- Encoding and fileformat
              local encoding = vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding
              local format = vim.bo.fileformat
              local enc_part = encoding .. '[' .. format .. ']'

              return ft_part .. ' ' .. enc_part
            end,
          },
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    }
  end,
}
