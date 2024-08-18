local cyberpunk = require('utils.cyberpunk_theme')

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
      comments = {},
      keywords = {},
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = 'dark', -- style for sidebars, see below
      floats = 'transparent', -- style for floating windows
    },

    -- Change the "hint" color to the "orange" color, and make the "error" color bright red
    on_colors = function(colors)
      colors.border_highlight = cyberpunk.core.border
      colors.hint = '#41a6b5'
    end,

    on_highlights = function(highlights, colors)
      local function set_highlight(groups, style)
        for _, group in ipairs(groups) do
          highlights[group] = style
        end
      end

      highlights['CursorLine'] = { bg = '' }
      highlights['CursorLineNr'] = { bold = true, fg = cyberpunk.core.green }

      highlights['DiagnosticVirtualTextError'] = { bg = '', fg = colors.error, bold = true } -- Used for "Error" diagnostic virtual text
      highlights['DiagnosticVirtualTextWarn'] = { bg = '', fg = colors.warning, bold = true } -- Used for "Warning" diagnostic virtual text
      highlights['DiagnosticVirtualTextInfo'] = { bg = '', fg = colors.info, bold = true } -- Used for "Information" diagnostic virtual text
      highlights['DiagnosticVirtualTextHint'] = { bg = '', fg = colors.hint, bold = true } -- Used for "Hint" diagnostic virtual text

      highlights['@lsp.type.parameter'] = { fg = colors.fg, underline = true }

      set_highlight({ 'TelescopePromptBorder', 'TelescopePromptTitle' }, { fg = cyberpunk.core.yellow })

      highlights['NoiceCmdlinePopupBorderCmdline'] = { fg = cyberpunk.core.magenta }
      highlights['NoiceCmdlineIcon'] = { fg = cyberpunk.core.green }
      highlights['NoiceCmdlinePopupBorderSearch'] = { fg = cyberpunk.core.yellow }
      highlights['NoiceCmdlineIconSearch'] = { fg = cyberpunk.core.red }

      set_highlight({ 'LineNr', 'LineNrAbove', 'LineNrBelow' }, { fg = cyberpunk.core.light_black })

      set_highlight({ '@lsp.type.interface.typescriptreact' }, { fg = cyberpunk.lsp.interface })
      set_highlight({ '@keyword.operator', '@operator' }, { fg = '#fca7ea' })
      set_highlight({ '@keyword.import', '@keyword.return' }, { fg = cyberpunk.lsp.keyword_red })
      set_highlight({ '@tag.builtin.tsx' }, { fg = cyberpunk.lsp.html_tag })

      set_highlight({ '@lsp.type.type', '@type.builtin' }, { fg = cyberpunk.lsp.builtin })
      set_highlight({ '@boolean', '@number', '@constant.builtin' }, { fg = cyberpunk.lsp.builtin_bright })
      set_highlight({ '@tag.attribute.tsx' }, { fg = colors.orange })
      set_highlight({ '@lsp.type.enum' }, { fg = cyberpunk.lsp.enum })
      set_highlight({ '@lsp.type.namespace.typescriptreact' }, { fg = cyberpunk.lsp.weirdbrown })
      -- Neon blue
      set_highlight({ '@tag.tsx' }, 'PreProc')
      set_highlight({ '@constant' }, { fg = colors.fg })
      set_highlight({ '@string' }, { fg = cyberpunk.lsp.string })
      set_highlight({ 'NeoTreeGitModified' }, { fg = colors.magenta })
      set_highlight({
        '@lsp.typemod.class.defaultLibrary.typescript',
        '@lsp.typemod.class.defaultLibrary.typescriptreact',
        '@lsp.type.class',
      }, { fg = cyberpunk.lsp.class })
      -- tky green1
      set_highlight({ '@lsp.type.enumMember' }, '@Property')
      -- tky green
      set_highlight({ 'NeoTreeGitUntracked' }, { fg = colors.green })
    end,

    cache = true,

    plugins = {
      auto = true,
    },
  },
}
