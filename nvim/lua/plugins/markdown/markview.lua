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
          ['map'] = create_callout('map', '', 'MarkviewBlockQuoteMap'),
          ['price'] = create_callout('price', '', 'MarkviewBlockQuotePrice'),
          ['more'] = create_callout('more', '󰮍 ', 'MarkviewBlockQuoteMore'),
          ['signpost'] = create_callout('signpost', ' ', 'MarkviewBlockQuoteGlob'),
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
          ['discord%.com'] = {
            icon = ' ',
            hl = 'MarkviewPalette6Fg',
          },
          ['figma%.com'] = {
            icon = ' ',
            hl = 'MarkviewPalette6Fg',
          },
          ['google%.com/document'] = {
            icon = ' ',
            hl = 'MarkviewPalette6Fg',
          },
          ['google%.com/spreadsheets'] = {
            icon = '󱎏 ',
            hl = 'MarkviewPalette6Fg',
          },
          ['mail.google%.com'] = {
            icon = ' ',
            hl = 'MarkviewPalette6Fg',
          },
          ['maps.app.goo.gl'] = {
            icon = ' ',
            hl = 'MarkviewPalette6Fg',
          },
          ['airbnb.com*'] = {
            icon = ' ',
            hl = 'MarkviewPalette6Fg',
          },
          ['booking.com'] = {
            icon = ' ',
            hl = 'MarkviewPalette6Fg',
          },
          ['stayz.com*'] = {
            icon = ' ',
            hl = 'MarkviewPalette6Fg',
          },
        },
        internal_links = { enable = true },
        escapes = { enable = true },
        footnotes = {},
      },

      html = {},
      latex = {
        enable = true,

        blocks = {
          enable = true,

          hl = 'MarkviewCode',
          pad_char = ' ',
          pad_amount = 3,

          text = '  LaTeX ',
          text_hl = 'MarkviewCodeInfo',
        },
        commands = {
          enable = true,
        },
        escapes = {
          enable = true,
        },
        fonts = {
          enable = true,

          default = {
            enable = true,
            hl = 'MarkviewSpecial',
          },

          mathbf = { enable = true },
          mathbfit = { enable = true },
          mathcal = { enable = true },
          mathbfscr = { enable = true },
          mathfrak = { enable = true },
          mathbb = { enable = true },
          mathbffrak = { enable = true },
          mathsf = { enable = true },
          mathsfbf = { enable = true },
          mathsfit = { enable = true },
          mathsfbfit = { enable = true },
          mathtt = { enable = true },
          mathrm = { enable = true },
        },
        parenthesis = {
          enable = true,
        },
        subscripts = {
          enable = true,
        },
        texts = {
          enable = true,
        },
      },
      yaml = {
        enable = true,
        properties = {
          enable = true,

          data_types = {
            ['text'] = {
              text = '󰗊 ',
              hl = 'MarkviewIcon4',
            },
            ['list'] = {
              text = '󰝖 ',
              hl = 'MarkviewIcon5',
            },
            ['number'] = {
              text = ' ',
              hl = 'MarkviewIcon6',
            },
            ['checkbox'] = {
              ---@diagnostic disable
              text = function(_, item)
                return item.value == 'true' and '󰄲 ' or '󰄱 '
              end,
              ---@diagnostic enable
              hl = 'MarkviewIcon6',
            },
            ['date'] = {
              text = '󰃭 ',
              hl = 'MarkviewIcon2',
            },
            ['date_&_time'] = {
              text = '󰥔 ',
              hl = 'MarkviewIcon3',
            },
          },

          default = {
            use_types = true,

            border_top = nil,
            border_middle = '│',
            border_bottom = '╰',

            border_hl = nil,
          },

          ['^tags$'] = {
            use_types = false,

            text = '󰓹 ',
            hl = 'MarkviewIconKeywordPurple',
          },
          ['^categories$'] = {
            use_types = false,

            text = '󱡠 ',
            hl = 'MarkviewIconDefault',
          },
          ['^aliases$'] = {
            match_string = '^aliases$',
            use_types = false,

            text = '󱞫 ',
            hl = 'MarkviewIconPink',
          },
          ['^ticket$'] = {
            use_types = false,
            match_string = '^ticket$',

            text = ' ',
            hl = 'MarkviewIconDefault',
          },
          ['^type$'] = {
            match_string = '^type$',
            use_types = false,

            text = ' ',
            hl = 'MarkviewIconKeywordRed',
          },
          ['^id$'] = {
            match_string = '^id$',
            use_types = false,

            text = ' ',
            hl = 'MarkviewIconPink',
          },
          ['^date_created$'] = {
            match_string = '^date_created$',
            use_types = false,

            text = '󰃳 ',
            hl = 'MarkviewIconDefault',
          },
          ['^orgs$'] = {
            match_string = '^orgs$',
            use_types = false,

            text = ' ',
            hl = 'MarkviewIconDefault',
          },
          ['^completed$'] = {
            match_string = '^completed$',
            use_types = false,

            text = '󰦕 ',
            hl = 'MarkviewIconDefault',
          },
          ['^permalink$'] = {
            match_string = '^permalink$',
            use_types = false,

            text = ' ',
            hl = 'MarkviewIcon2',
          },
          ['^description$'] = {
            match_string = '^description$',
            use_types = false,

            text = '󰋼 ',
            hl = 'MarkviewIcon0',
          },
        },
      },
    },
  },
}
