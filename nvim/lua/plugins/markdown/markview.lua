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
    ft = 'markdown', -- If you decide to lazy-load anyway
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'echasnovski/mini.icons',
    },
    config = function()
      require('markview').setup({

        preview = {
          enable = true,
          buf_ignore = { 'nofile' },
          debounce = 50,
          hybrid_modes = { 'n' },
        },

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
          horizontal_rules = {},
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

              text = '',
              hl = 'MarkviewListItemStar',
            },

            marker_dot = {
              add_padding = true,
              conceal_on_checkboxes = true,
            },

            marker_parenthesis = {
              add_padding = true,
              conceal_on_checkboxes = true,
            },
          },
          tables = {},
        },

        markdown_inline = {
          inline_codes = { enable = false },
          hyperlinks = { enable = true },
          internal_links = { enable = true },
          footnotes = {},
        },

        html = {},
        latex = {},
      })
    end,
  },
}
