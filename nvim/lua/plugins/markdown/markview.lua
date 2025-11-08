local function create_callout(match_string, icon, hl)
  return {
    -- match_string = match_string,
    hl = hl,
    preview_hl = nil,
    title = true,
    icon = icon,
    preview = icon .. string.upper(string.sub(match_string, 1, 1)) .. string.sub(match_string, 2),
    border = '▋',
    border_hl = nil,
  }
end

return {
  {
    'OXY2DEV/markview.nvim',
    -- lazy = false, -- Recommended
    ft = { 'markdown', 'markdown.gh', 'Avante', 'codecompanion' }, -- If you decide to lazy-load anyway
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons',
    },
    opts = {
      preview = {
        enable = true,
        enable_hybrid_mode = true,
        linewise_hybrid_mode = false,
        raw_previews = nil,
        filetypes = { 'markdown', 'markdown.gh', 'Avante', 'codecompanion' },
        ignore_buftypes = {},
        buf_ignore = { 'nofile' },
        debounce = 50,
        modes = { 'n', 'no', 'c' },
        hybrid_modes = { 'n' },
        icon_provider = 'mini',
      },
      max_length = 99999,

      -- Rendering related configuration
      markdown = {
        code_blocks = {
          enable = true,
          icons = 'devicons',
          sign = false,
          border_hl = 'MarkviewCode',
          default = {
            block_hl = 'MarkviewBlockCode',
            pad_hl = 'MarkviewBlockCode',
          },
        },
        block_quotes = {
          enable = true,
          default = {
            border = '▋',
            hl = 'MarkviewBlockQuoteDefault',
            title = true,
          },
          --- Configuration for custom block quotes
          ['gem'] = create_callout('gem', ' ', 'MarkviewBlockQuoteGem'),
          ['candy'] = create_callout('candy', '󱥳 ', 'MarkviewBlockQuoteCandy'),
          ['tip'] = create_callout('tip', '󰌶 ', 'MarkviewBlockQuoteTip'),
          ['note'] = create_callout('note', ' ', 'MarkviewBlockQuoteNote'),
          ['dev'] = create_callout('dev', '󱚤 ', 'MarkviewBlockQuoteDev'),
          ['warn'] = create_callout('warn', ' ', 'MarkviewBlockQuoteWarn'),
          ['important'] = create_callout('important', ' ', 'MarkviewBlockQuoteImportant'),
          ['success'] = create_callout('success', ' ', 'MarkviewBlockQuoteSuccess'),
          ['fail'] = create_callout('fail', ' ', 'MarkviewBlockQuoteFail'),
          ['info'] = create_callout('info', '󰋽 ', 'MarkviewBlockQuoteInfo'),
        },
        headings = { enable = false },
        horizontal_rules = {
          enable = true,
        },
        list_items = {
          enable = true,
          indent_size = 2,
          shift_width = 1,
          marker_minus = {
            add_padding = true,
            conceal_on_checkboxes = true,

            text = '',
            hl = 'MarkviewListItemMinus',
          },

          marker_plus = {
            add_padding = true,
            conceal_on_checkboxes = true,

            text = '',
            hl = 'MarkviewListItemPlus',
          },

          marker_star = {
            add_padding = true,
            conceal_on_checkboxes = true,

            text = '',
            hl = 'MarkviewListItemStar',
          },

          marker_dot = {
            add_padding = true,
            conceal_on_checkboxes = true,
            text = '',
          },

          marker_parenthesis = {
            add_padding = true,
            conceal_on_checkboxes = true,
          },
        },
        tables = {
          enable = true,
        },
      },

      markdown_inline = {
        checkboxes = {
          enable = true,
          checked = { text = '󰗠', hl = 'MarkviewCheckboxChecked', scope_hl = 'MarkviewCheckboxChecked' },
          unchecked = { text = '󰄰', hl = 'MarkviewCheckboxUnchecked', scope_hl = 'MarkviewCheckboxUnchecked' },
          ['-'] = { text = '󰍶', hl = 'MarkviewCheckboxCancelled', scope_hl = 'MarkviewCheckboxCancelled' },
          ['/'] = { text = '󱎖', hl = 'MarkviewCheckboxHalf', scope_hl = 'MarkviewCheckboxHalf' },
          ['?'] = { text = '󰋗', hl = 'MarkviewCheckboxPending', scope_hl = 'MarkviewCheckboxPending' },
          ['!'] = { text = '󰀦', hl = 'MarkviewBlockQuoteWarn', scope_hl = 'MarkviewBlockQuoteWarn' },
          ['*'] = { text = '󰓎', hl = 'MarkviewCheckboxStar', scope_hl = 'MarkviewCheckboxStar' },
        },

        inline_codes = {
          enable = true,
          padding_left = '',
          padding_right = '',
        },

        hyperlinks = {
          enable = true,

          ['notion%.so'] = {
            icon = ' ',
            hl = 'MarkviewPalette6Fg',
          },
        },
        internal_links = { enable = true },
        escapes = { enable = true },
        footnotes = {},
      },

      html = {},
      latex = {},
    },
  },
}
