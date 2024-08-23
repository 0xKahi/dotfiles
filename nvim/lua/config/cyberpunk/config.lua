-- curently only configured for tokyonight_moon theme
-- TODO: refactor into colortheme
local M = {}

local cyberpunk = require('config.cyberpunk.colors')

function M.apply_highlight(highlights, colors)
  highlights['CursorLine'] = { bg = '' }
  highlights['CursorLineNr'] = { bold = true, fg = cyberpunk.core.green }

  highlights['LineNr'] = { fg = cyberpunk.core.light_black }
  highlights['LineNrAbove'] = { fg = cyberpunk.core.light_black }
  highlights['LineNrBelow'] = { fg = cyberpunk.core.light_black }

  highlights['DiagnosticVirtualTextError'] = { bg = '', fg = colors.error, bold = true } -- Used for "Error" diagnostic virtual text
  highlights['DiagnosticVirtualTextWarn'] = { bg = '', fg = colors.warning, bold = true } -- Used for "Warning" diagnostic virtual text
  highlights['DiagnosticVirtualTextInfo'] = { bg = '', fg = colors.info, bold = true } -- Used for "Information" diagnostic virtual text
  highlights['DiagnosticVirtualTextHint'] = { bg = '', fg = colors.hint, bold = true } -- Used for "Hint" diagnostic virtual text

  highlights['NoiceCmdlinePopupBorderCmdline'] = { fg = cyberpunk.core.red }
  highlights['NoiceCmdlineIconSearch'] = { fg = cyberpunk.core.red }
  highlights['NoiceCmdlinePopupBorderSearch'] = { fg = cyberpunk.core.yellow }
  highlights['NoiceCmdlineIcon'] = { fg = cyberpunk.core.yellow }

  highlights['TelescopePromptBorder'] = { fg = cyberpunk.core.yellow }
  highlights['TelescopePromptTitle'] = { fg = cyberpunk.core.blue }
  highlights['TelescopeMatching'] = { fg = cyberpunk.core.bright_yellow }

  highlights['MiniIndentscopeSymbol'] = { fg = cyberpunk.core.green, nocombine = true }

  highlights['NeoTreeGitModified'] = { fg = cyberpunk.core.bright_magenta }
  highlights['NeoTreeGitUntracked'] = { fg = cyberpunk.core.bright_green }
  highlights['NeoTreeCursorLine'] = { bold = true, bg = cyberpunk.core.highlight }

  highlights['MiniDiffSignChange'] = { fg = cyberpunk.core.bright_magenta }
  highlights['MiniDiffSignAdd'] = { fg = cyberpunk.core.bright_green }
  highlights['MiniDiffSignDelete'] = { fg = cyberpunk.core.bright_red }
  highlights['MiniDiffSignIgnored'] = { fg = cyberpunk.lsp.comments }

  highlights['ArrowFileIndex'] = { fg = cyberpunk.core.green }
  highlights['ArrowCurrentFile'] = { fg = cyberpunk.core.blue }
  highlights['ArrowAction'] = { fg = cyberpunk.core.cyan }
  highlights['ArrowDeleteMode'] = { fg = cyberpunk.core.red }
end

function M.apply_lsp_highlights(highlights)
  local function set_highlight(groups, style)
    for _, group in ipairs(groups) do
      highlights[group] = style
    end
  end

  set_highlight({ '@lsp.type.interface.typescriptreact' }, { fg = cyberpunk.lsp.interface })
  set_highlight({ '@keyword.operator', '@operator' }, { fg = cyberpunk.lsp.operator })
  set_highlight({ '@keyword.import', '@keyword.return' }, { fg = cyberpunk.lsp.keyword_red })
  set_highlight({ '@tag.builtin.tsx' }, { fg = cyberpunk.lsp.html_tag })

  set_highlight({ '@lsp.type.type', '@type.builtin' }, { fg = cyberpunk.lsp.builtin })
  set_highlight({ '@boolean', '@number', '@constant.builtin' }, { fg = cyberpunk.lsp.builtin_bright })
  set_highlight({
    '@lsp.typemod.class.defaultLibrary.typescript',
    '@lsp.typemod.class.defaultLibrary.typescriptreact',
    '@lsp.type.class',
  }, { fg = cyberpunk.lsp.class })

  highlights['@lsp.type.parameter'] = { fg = cyberpunk.core.fg, underline = true }
  highlights['@tag.attribute.tsx'] = { fg = cyberpunk.core.orange }
  highlights['@tag.tsx'] = { fg = cyberpunk.lsp.react_tag }
  highlights['@lsp.type.enum'] = { fg = cyberpunk.lsp.enum }
  highlights['@lsp.type.namespace.typescriptreact'] = { fg = cyberpunk.lsp.weirdbrown }
  highlights['@constant'] = { fg = cyberpunk.core.fg }
  highlights['@string'] = { fg = cyberpunk.lsp.string }
  highlights['@lsp.type.enumMember'] = { fg = cyberpunk.lsp.property }
end

function M.apply_colors(colors)
  colors['border_highlight'] = cyberpunk.core.border
  colors['hint'] = cyberpunk.core.hint
end

return M
