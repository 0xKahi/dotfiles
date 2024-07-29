return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {

    style = 'moon',
    transparent = true,
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = 'dark', -- style for sidebars, see below
      floats = 'transparent', -- style for floating windows
    },

    -- Change the "hint" color to the "orange" color, and make the "error" color bright red
    on_colors = function(colors)
      --colors.border_highlight = '#8cf67a'
      colors.border_highlight = '#00FF9C'
      colors.hint = '#41a6b5'
    end,

    on_highlights = function(highlights, colors)
      highlights['DiagnosticVirtualTextError'] = { bg = '', fg = colors.error, bold = true } -- Used for "Error" diagnostic virtual text
      highlights['DiagnosticVirtualTextWarn'] = { bg = '', fg = colors.warning, bold = true } -- Used for "Warning" diagnostic virtual text
      highlights['DiagnosticVirtualTextInfo'] = { bg = '', fg = colors.info, bold = true } -- Used for "Information" diagnostic virtual text
      highlights['DiagnosticVirtualTextHint'] = { bg = '', fg = colors.hint, bold = true } -- Used for "Hint" diagnostic virtual text

      highlights['@lsp.type.parameter'] = { fg = colors.fg, underline = true }

      local function set_highlight(groups, style)
        for _, group in ipairs(groups) do
          highlights[group] = style
        end
      end

      -- lighter black
      set_highlight({ 'LineNr', 'LineNrAbove', 'LineNrBelow' }, { fg = '#545e8a' })
      -- interface purple
      -- set_highlight({ '@lsp.type.interface.typescriptreact' }, { fg = '#6095FF' })

      -- new interface purple
      set_highlight({ '@lsp.type.interface.typescriptreact' }, { fg = '#6F94FF' })
      -- tky red/pink
      set_highlight({ '@keyword.operator', '@operator' }, { fg = '#fca7ea' })
      -- red
      set_highlight({ '@keyword.import', '@keyword.return' }, { fg = '#f97e9d' })
      -- html tag red
      set_highlight({ '@tag.builtin.tsx' }, { fg = '#ff757f' })
      -- yellow
      set_highlight({ '@lsp.type.type', '@type.builtin' }, { fg = '#E5D97D' })
      -- neon yellow
      set_highlight({ '@boolean', '@number', '@constant.builtin' }, { fg = '#ffe96c' })
      -- tky moon orange
      set_highlight({ '@tag.attribute.tsx' }, { fg = colors.orange })
      -- enum orange
      set_highlight({ '@lsp.type.enum' }, { fg = '#ffbfa6' })
      -- weird brown
      set_highlight({ '@lsp.type.namespace.typescriptreact' }, { fg = '#D1C5C0' })
      -- Neon blue
      set_highlight({ '@tag.tsx' }, 'PreProc')
      -- white
      set_highlight({ '@constant' }, { fg = colors.fg })
      -- light blue
      set_highlight({ '@string' }, { fg = '#a4d6ff' })
      -- tky purple
      set_highlight({ 'NeoTreeGitModified' }, { fg = colors.magenta })
      -- light class purple
      set_highlight({ '@lsp.typemod.class.defaultLibrary.typescriptreact', '@lsp.type.class' }, { fg = '#b4baff' })
      -- tky green1
      set_highlight({ '@lsp.type.enumMember' }, '@Property')
      -- tky green
      set_highlight({ 'NeoTreeGitUntracked' }, { fg = colors.green })
    end,
    plugins = {
      auto = true,
    },
  },
}
