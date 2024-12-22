-- curently only configured for tokyonight_moon theme
-- TODO: refactor into colortheme
local M = {}

local cyberpunk = require('config.cyberpunk.colors')

local function set_highlight(highlights, groups, style)
  for _, group in ipairs(groups) do
    highlights[group] = style
  end
end

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
  highlights['TelescopePromptTitle'] = { fg = cyberpunk.core.red }
  highlights['TelescopePreviewTitle'] = { fg = cyberpunk.core.magenta }
  highlights['TelescopeResultsNumber'] = { fg = cyberpunk.core.cyan }
  highlights['TelescopePreviewBorder'] = { fg = cyberpunk.core.blue }
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

  highlights['GrugFarHelpHeader'] = { fg = cyberpunk.core.bright_yellow }
  highlights['GrugFarResultsNumberLabel'] = { fg = cyberpunk.core.bright_magenta }
  highlights['GrugFarInputLabel'] = { fg = cyberpunk.core.bright_blue }
  highlights['GrugFarResultsPath'] = { fg = cyberpunk.core.neon_green }
  highlights['GrugFarHelpWinActionText'] = { fg = cyberpunk.core.yellow }
  highlights['GrugFarHelpWinActionKey'] = { fg = cyberpunk.core.green }
  set_highlight(highlights, { 'GrugFarResultsLineNo', 'GrugFarResultsLineColumn' }, { fg = cyberpunk.markview.dev })
  highlights['GrugFarResultsAddIndicator'] = { fg = cyberpunk.core.bright_green }
  highlights['GrugFarResultsRemoveIndicator'] = { fg = cyberpunk.core.bright_red }
  highlights['GrugFarResultsChangeIndicator'] = { fg = cyberpunk.core.bright_magenta }

  highlights['LazyGitFloat'] = { fg = cyberpunk.core.fg }
  highlights['LazyGitBorder'] = { fg = cyberpunk.core.neon_green }
end

function M.apply_lsp_highlights(highlights)
  set_highlight(highlights, { '@lsp.type.interface.typescriptreact' }, { fg = cyberpunk.lsp.interface })
  set_highlight(highlights, { '@keyword.operator', '@operator' }, { fg = cyberpunk.lsp.operator })
  set_highlight(highlights, { '@keyword.import', '@keyword.return' }, { fg = cyberpunk.lsp.keyword_red })
  set_highlight(highlights, { '@tag.builtin.tsx' }, { fg = cyberpunk.lsp.html_tag })

  set_highlight(highlights, { '@lsp.type.type', '@type.builtin' }, { fg = cyberpunk.lsp.builtin })
  set_highlight(highlights, { '@boolean', '@number', '@constant.builtin' }, { fg = cyberpunk.lsp.builtin_bright })
  set_highlight(highlights, {
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

  highlights['@string.special.url.http'] = { fg = cyberpunk.lsp.string, underline = true, italic = true }
  highlights['@function.method.http'] = { fg = cyberpunk.lsp.keyword_purple }
  highlights['@constant.http'] = { fg = cyberpunk.lsp.enum }
  highlights['@string.http'] = { fg = cyberpunk.core.bright_green }

  highlights['@markup.raw.block.markdown'] = { fg = cyberpunk.core.green }
  highlights['@markup.heading.2.markdown'] = { fg = cyberpunk.core.magenta }
  highlights['@markup.heading.3.markdown'] = { fg = cyberpunk.core.orange }
  highlights['@markup.raw.markdown_inline'] = {
    bg = cyberpunk.core.dark_bg,
    fg = cyberpunk.core.neon_blue,
  }
end

function M.apply_markview_highlights(highlights)
  highlights['MarkviewCode'] = { bg = cyberpunk.core.dark_bg }
  highlights['MarkviewBlockQuoteGem'] = { fg = cyberpunk.markview.gem }
  highlights['MarkviewBlockQuoteCandy'] = { fg = cyberpunk.markview.candy }
  highlights['MarkviewBlockQuoteTip'] = { fg = cyberpunk.markview.tip }
  highlights['MarkviewBlockQuoteNote'] = { fg = cyberpunk.markview.note }
  highlights['MarkviewBlockQuoteDev'] = { fg = cyberpunk.markview.dev }
  highlights['MarkviewBlockQuoteWarn'] = { fg = cyberpunk.markview.warn }
  highlights['MarkviewBlockQuoteSuccess'] = { fg = cyberpunk.markview.success }
  highlights['MarkviewBlockQuoteFail'] = { fg = cyberpunk.markview.fail }
  highlights['MarkviewBlockQuoteImportant'] = { fg = cyberpunk.markview.important }
  highlights['MarkviewBlockQuoteInfo'] = { fg = cyberpunk.markview.info }
end

function M.apply_colors(colors)
  colors['border_highlight'] = cyberpunk.core.neon_green
  colors['hint'] = cyberpunk.core.hint
end

return M
