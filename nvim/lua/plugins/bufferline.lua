return {
  'akinsho/bufferline.nvim',
  dependencies = {
    -- 'nvim-tree/nvim-web-devicons',
    'echasnovski/mini.icons',
  },
  config = function()
    local cyberpunk = require('config.cyberpunk.colors')
    require('bufferline').setup({
      options = {
        mode = 'buffers', -- set to "tabs" to only show tabpages instead
        themable = false, -- allows highlight groups to be overriden i.e. sets highlights as default
        numbers = 'none', -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = 'bdelete! %d', -- can be a string | function, | false see "Mouse actions"
        right_mouse_command = 'bdelete! %d', -- can be a string | function | false, see "Mouse actions"
        left_mouse_command = 'buffer %d', -- can be a string | function, | false see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        buffer_close_icon = '✗',
        close_icon = '',
        -- path_components = 1, -- Show only the file name without the directory
        modified_icon = '●',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 30,
        max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
        tab_size = 20,
        truncate_names = false, -- whether or not tab names should be truncated
        diagnostics = false,
        diagnostics_update_in_insert = false,
        color_icons = true,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        separator_style = { '│', '│' }, -- | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        show_tab_indicators = false,
        indicator = {
          -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = 'none', -- Options: 'icon', 'underline', 'none'
        },
        icon_pinned = '󰐃',
        minimum_padding = 1,
        maximum_padding = 5,
        maximum_length = 15,
        sort_by = 'insert_at_end',
      },
      highlights = {
        separator = {
          fg = cyberpunk.core.bright_magenta,
        },
        buffer_selected = {
          bold = false,
          italic = false,
          fg = cyberpunk.core.bright_green,
        },
        buffer_visible = {
          fg = cyberpunk.core.fg,
          bg = '',
        },
        background = {
          fg = cyberpunk.lsp.comments,
          bg = '',
        },
        fill = {
          bg = '',
          fg = '',
        },
        modified = {
          fg = cyberpunk.core.fg,
          bg = '',
        },
        modified_visible = {
          fg = cyberpunk.core.bright_cyan,
          bg = '',
        },
        modified_selected = {
          fg = cyberpunk.core.bright_yellow,
          bg = '',
        },
      },
    })

    vim.api.nvim_set_keymap(
      'n',
      '<leader>bp',
      ':BufferLinePick<enter>',
      { desc = '[B]uffer line [P]ick', noremap = false }
    )
    vim.api.nvim_set_keymap(
      'n',
      '<leader>bc',
      ':BufferLinePickClose<enter>',
      { desc = '[B]uffer line pick [C]lose', noremap = false }
    )
    vim.api.nvim_set_keymap(
      'n',
      '<leader>bP',
      ':BufferLineTogglePin<enter>',
      { desc = '[B]uffer [P]in', noremap = false }
    )
  end,
}
