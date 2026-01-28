-- curently only configured for tokyonight_moon theme
-- TODO: refactor into colortheme
local cyberpunk = require('config.cyberpunk.colors')

----------------------------------------
---------------- utils -----------------
----------------------------------------

local function set_highlight(highlights, groups, style)
  for _, group in ipairs(groups) do
    highlights[group] = style
  end
end

-- to omit certain global highlights back to default
local function reset_lsp_highlights(highlights, filetype, groups)
  for _, group in ipairs(groups) do
    highlights[group .. '.' .. filetype] = {}
  end
end

----------------------------------------
-------- neovim core highlights --------
----------------------------------------

local function set_nvim_core(highlights, colors)
  highlights['TabLineFill'] = { fg = '', bg = '' }
  highlights['TabLine'] = { fg = cyberpunk.lsp.comments, bg = '' }
  highlights['CursorLine'] = { bg = '' }
  highlights['CursorLineNr'] = { bold = true, fg = cyberpunk.core.green }
  highlights['HighlightYank'] = { bg = cyberpunk.core.highlight }

  highlights['LineNr'] = { fg = cyberpunk.core.light_black }
  highlights['LineNrAbove'] = { fg = cyberpunk.core.light_black }
  highlights['LineNrBelow'] = { fg = cyberpunk.core.light_black }

  highlights['DiagnosticVirtualTextError'] = { bg = '', fg = colors.error, bold = true } -- Used for "Error" diagnostic virtual text
  highlights['DiagnosticVirtualTextWarn'] = { bg = '', fg = colors.warning, bold = true } -- Used for "Warning" diagnostic virtual text
  highlights['DiagnosticVirtualTextInfo'] = { bg = '', fg = colors.info, bold = true } -- Used for "Information" diagnostic virtual text
  highlights['DiagnosticVirtualTextHint'] = { bg = '', fg = colors.hint, bold = true } -- Used for "Hint" diagnostic virtual text
end

----------------------------------------
---------- custom highlights -----------
----------------------------------------

local function set_jojo_git(highlights)
  highlights['JoJoGitModified'] = { fg = cyberpunk.git.modified }
  highlights['JoJoGitUntracked'] = { fg = cyberpunk.git.untracked }
  highlights['JoJoGitStaged'] = { fg = cyberpunk.git.staged }
  highlights['JoJoGitConflict'] = {
    fg = cyberpunk.git.conflict,
    bold = true,
    italic = true,
  }
  highlights['JoJoGitAdded'] = { fg = cyberpunk.git.added }
  highlights['JoJoGitDeleted'] = { fg = cyberpunk.git.deleted }
  highlights['JoJoGitIgnored'] = { fg = cyberpunk.git.ignored }
  highlights['JoJoGitChanged'] = { fg = cyberpunk.git.changed }
end

----------------------------------------
---------- plugins highlights ----------
----------------------------------------

local function set_noice_plugin(highlights)
  highlights['NoiceCmdlinePopupBorderCmdline'] = { fg = cyberpunk.core.red }
  highlights['NoiceCmdlineIconSearch'] = { fg = cyberpunk.core.red }
  highlights['NoiceCmdlinePopupBorderSearch'] = { fg = cyberpunk.core.yellow }
  highlights['NoiceCmdlineIcon'] = { fg = cyberpunk.core.yellow }
end

local function set_telescope_plugin(highlights)
  highlights['TelescopePromptBorder'] = { fg = cyberpunk.core.yellow }
  highlights['TelescopePromptTitle'] = { fg = cyberpunk.core.red }
  highlights['TelescopePreviewTitle'] = { fg = cyberpunk.core.magenta }
  highlights['TelescopeResultsNumber'] = { fg = cyberpunk.core.cyan }
  highlights['TelescopePreviewBorder'] = { fg = cyberpunk.core.blue }
  highlights['TelescopeMatching'] = { fg = cyberpunk.core.bright_yellow }
end

local function set_neotree_plugin(highlights)
  highlights['NeoTreeGitModified'] = { link = 'JoJoGitModified' }
  highlights['NeoTreeGitUntracked'] = { link = 'JoJoGitUntracked' }
  highlights['NeoTreeGitStaged'] = { link = 'JoJoGitStaged' }
  highlights['NeoTreeGitConflict'] = { link = 'JoJoGitConflict' }
  highlights['NeoTreeGitAdded'] = { link = 'JoJoGitAdded' }
  highlights['NeoTreeGitDeleted'] = { link = 'JoJoGitDeleted' }
  highlights['NeoTreeGitIgnored'] = { link = 'JoJoGitIgnored' }
  highlights['NeoTreeCursorLine'] = { bold = true, bg = cyberpunk.core.highlight }
end

local function set_mini_plugin(highlights)
  highlights['MiniIndentscopeSymbol'] = { fg = cyberpunk.core.green, nocombine = true }

  highlights['MiniDiffSignChange'] = { fg = cyberpunk.core.bright_magenta }
  highlights['MiniDiffSignAdd'] = { fg = cyberpunk.core.bright_green }
  highlights['MiniDiffSignDelete'] = { fg = cyberpunk.core.bright_red }
  highlights['MiniDiffSignIgnored'] = { fg = cyberpunk.lsp.comments }

  highlights['MiniFilesBorderModified'] = { fg = cyberpunk.core.red }
  highlights['MiniFilesTitleFocused'] = { fg = cyberpunk.core.bright_yellow }
end

local function set_arrow_plugin(highlights)
  highlights['ArrowFileIndex'] = { fg = cyberpunk.core.green }
  highlights['ArrowCurrentFile'] = { fg = cyberpunk.core.blue }
  highlights['ArrowAction'] = { fg = cyberpunk.core.cyan }
  highlights['ArrowDeleteMode'] = { fg = cyberpunk.core.red }
  highlights['ArrowSplitMode'] = { fg = cyberpunk.core.magenta }
  highlights['ArrowDirBorder'] = { fg = cyberpunk.core.neon_blue }
  highlights['ArrowFileBorder'] = { fg = cyberpunk.core.neon_blue }
end

local function set_grugfar_plugin(highlights)
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
end

local function set_lazygit_plugin(highlights)
  highlights['LazyGitFloat'] = { fg = cyberpunk.core.fg }
  highlights['LazyGitBorder'] = { fg = cyberpunk.core.neon_green }
end

local function set_blink_plugin(highlights)
  highlights['BlinkCmpScrollBarThumb'] = { bg = cyberpunk.core.neon_blue }
  highlights['BlinkCmpMenuSelection'] = { bg = cyberpunk.core.highlight2 }
  highlights['BlinkCmpKindClass'] = { fg = cyberpunk.lsp.class }
end

local function set_snacks_plugin(highlights)
  highlights['SnacksDashboardFooter'] = { fg = cyberpunk.core.bright_green }
  highlights['SnacksDashboardSpecial'] = { fg = cyberpunk.core.bright_magenta }
  highlights['SnacksDashboardFile'] = { fg = cyberpunk.core.bright_blue }

  highlights['SnacksPickerBoxTitle'] = { fg = cyberpunk.core.red }
  highlights['SnacksPickerInputBorder'] = { fg = cyberpunk.core.yellow }
  highlights['SnacksPickerInputTitle'] = { fg = cyberpunk.core.red }
  highlights['SnacksPickerPreviewTitle'] = { fg = cyberpunk.core.magenta }
  highlights['SnacksPickerPreviewBorder'] = { fg = cyberpunk.core.blue }
  highlights['SnacksPickerDir'] = { fg = cyberpunk.core.cyan }
  highlights['SnacksPickerPrompt'] = { fg = cyberpunk.core.red }
  highlights['SnacksPickerMatch'] = { fg = cyberpunk.core.bright_yellow }

  highlights['SnacksBackdrop'] = { bg = '', default = true }

  -- highlights['SnacksNotifierInfo'] = { link = 'DiagnosticInfo' }
  -- highlights['SnacksNotifierWarn'] = { link = 'DiagnosticWarn' }
  -- highlights['SnacksNotifierError'] = { link = 'DiagnosticError' }
  set_highlight(highlights, { 'SnacksNotifierTitleDebug', 'SnacksNotifierIconDebug' }, { link = 'Debug' })
  highlights['SnacksNotifierBorderDebug'] = { fg = '#B4637A' }
end

local function set_avante_plugin(highlights)
  highlights['AvanteTitle'] = { fg = cyberpunk.core.black, bg = cyberpunk.core.bright_green }
  highlights['AvanteSubTitle'] = { fg = cyberpunk.core.black, bg = cyberpunk.core.bright_cyan }
  highlights['AvanteThirdTitle'] = { fg = cyberpunk.core.white, bg = cyberpunk.core.semi_light_black }
  highlights['AvanteReversedTitle'] = { fg = cyberpunk.core.bright_green }
  highlights['AvanteReversedSubTitle'] = { fg = cyberpunk.core.bright_cyan }
  highlights['AvanteReversedThirdTitle'] = { fg = cyberpunk.core.semi_light_black }
  highlights['AvanteSidebarWinSeparator'] = { fg = cyberpunk.core.neon_blue }
  highlights['AvanteSidebarWinHorizontalSeparator'] = { fg = cyberpunk.core.neon_green, bg = '' }
  highlights['AvantePromptInputBorder'] = { fg = cyberpunk.core.neon_green, bg = '' }
  highlights['AvantePromptInput'] = { fg = cyberpunk.core.fg, bg = '' }
end

local function set_mcphub_plugin(highlights)
  highlights['MCPHubNormal'] = { fg = cyberpunk.core.fg, bg = '', default = true }
  highlights['MCPHubSuccess'] = { fg = cyberpunk.core.bright_green }
  highlights['MCPHubLink'] = { cterm = { underline = true }, underline = true, fg = cyberpunk.core.cyan }
  -- highlights['MCPHubHeaderAccent'] = { bg = cyberpunk.core.secondary_black, fg = cyberpunk.core.tky_blue }
  set_highlight(highlights, { 'MCPHubJsonNumber', 'MCPHubJsonBoolean' }, { fg = cyberpunk.lsp.builtin })
  highlights['MCPHubJsonNull'] = { fg = cyberpunk.lsp.builtin_bright }
  highlights['MCPHubJsonString'] = { fg = cyberpunk.lsp.string }
  highlights['MCPHubJsonProperty'] = { fg = cyberpunk.lsp.property }
  highlights['MCPHubJsonPunctuation'] = { fg = cyberpunk.lsp.delimiter }
  set_highlight(
    highlights,
    { 'MCPHubActiveItem', 'MCPHubSuccessFill' },
    { cterm = { bold = true }, bold = true, fg = '#1A1B26', bg = cyberpunk.core.bright_green }
  )
  highlights['MCPHubActiveItemMuted'] =
    { cterm = { bold = true }, bold = true, fg = cyberpunk.lsp.comments, bg = cyberpunk.core.bright_green }
  set_highlight(highlights, { 'MCPHubInfo', 'MCPHubCode' }, { fg = cyberpunk.core.bright_magenta })
end

local function set_markview_plugin(highlights)
  --- Palattes
  highlights['MarkviewPalette6Fg'] = { fg = cyberpunk.lsp.operator }

  --- Code Blocks
  highlights['MarkviewCode'] = { bg = cyberpunk.core.dark_bg }
  highlights['MarkviewInlineCode'] = { bg = cyberpunk.core.dark_bg, fg = cyberpunk.core.neon_blue }
  highlights['MarkviewBlockCode'] = { bg = cyberpunk.core.dark_bg }

  --- Block Quotes
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
  highlights['MarkviewBlockQuoteMap'] = { fg = cyberpunk.markview.map }
  highlights['MarkviewBlockQuotePrice'] = { fg = cyberpunk.markview.price }
  highlights['MarkviewBlockQuoteMore'] = { fg = cyberpunk.markview.more }
  highlights['MarkviewBlockQuoteGlob'] = { fg = cyberpunk.markview.glob }
  highlights['MarkviewBlockQuoteDefault'] = { fg = cyberpunk.core.bright_magenta }

  --- List Items
  highlights['MarkviewListItemMinus'] = { fg = cyberpunk.core.tky_blue }
  highlights['MarkviewListItemMinusScope'] = { fg = cyberpunk.core.bright_magenta }
  highlights['MarkviewListItemStar'] = { fg = cyberpunk.core.bright_yellow }

  --- Checkboxes
  highlights['MarkviewCheckboxUnchecked'] = { fg = cyberpunk.core.tky_blue }
  highlights['MarkviewCheckboxChecked'] = { fg = cyberpunk.lsp.property }
  highlights['MarkviewCheckboxCancelled'] = { fg = cyberpunk.core.light_black }
  highlights['MarkviewCheckboxPending'] = { fg = cyberpunk.markview.info }
  highlights['MarkviewCheckboxHalf'] = { fg = cyberpunk.markview.pending }
  highlights['MarkviewBlockQuoteWarn'] = { fg = cyberpunk.markview.warn }
  highlights['MarkviewCheckboxStar'] = { fg = cyberpunk.core.bright_yellow }
end

----------------------------------------
----------- Icons highlights -----------
----------------------------------------

local function set_icon_highlights(highlights)
  highlights['DefaultFolderIcon'] = { fg = '#82AAFF' }
  highlights['AppFolderIcon'] = { fg = '#EF8FA4' }
  highlights['LibraryFolderIcon'] = { fg = '#8EEDB0' }
  highlights['TestFolderIcon'] = { fg = '#0db9d7' }
  highlights['OpenCodeFolderIcon'] = { fg = '#9d7cd8' }
  highlights['SharedFolderIcon'] = { fg = '#8EEDB0' }
  highlights['NvimWorkspaceFolderIcon'] = { fg = '#508e38' }

  highlights['NestJsModuleIcon'] = { fg = '#FF757F' }
  highlights['NestJsServiceIcon'] = { fg = '#FFE675' }
  highlights['NestJsResolverIcon'] = { fg = '#4fd6be' }
  highlights['NestJsControllerIcon'] = { fg = '#75B4FF' }
  highlights['NestJsProcessorIcon'] = { fg = '#95C9F8' }
  highlights['E2ESpecIcon'] = { fg = '#3582de' }

  highlights['MiniIconDarkPurple'] = { fg = '#886CFF' }
end

----------------------------------------
------------ LSP highlights ------------
----------------------------------------

local function set_lsp_highlights(highlights)
  set_highlight(highlights, { '@boolean', '@number', '@constant.builtin' }, { fg = cyberpunk.lsp.builtin_bright })
  set_highlight(highlights, { '@keyword.operator', '@operator' }, { fg = cyberpunk.lsp.operator })
  set_highlight(highlights, { '@keyword.import', '@keyword.return' }, { fg = cyberpunk.lsp.keyword_red })
  set_highlight(highlights, { '@lsp.type.type', '@type.builtin' }, { fg = cyberpunk.lsp.builtin })

  highlights['@constant'] = { fg = cyberpunk.core.fg }
  highlights['@string'] = { fg = cyberpunk.lsp.string }
  highlights['@lsp.type.parameter'] = { fg = cyberpunk.core.fg, underline = true }
  highlights['@lsp.type.enum'] = { fg = cyberpunk.lsp.enum }
  highlights['@lsp.type.enumMember'] = { fg = cyberpunk.lsp.property }
  highlights['@lsp.type.class'] = { fg = cyberpunk.lsp.class }

  highlights['@lsp.type.namespace.typescriptreact'] = { fg = cyberpunk.lsp.weirdbrown }
  highlights['@lsp.type.interface.typescriptreact'] = { fg = cyberpunk.lsp.interface }
  highlights['@tag.tsx'] = { fg = cyberpunk.lsp.react_tag }
  highlights['@tag.attribute.tsx'] = { fg = cyberpunk.core.orange }
  highlights['@tag.builtin.tsx'] = { fg = cyberpunk.lsp.html_tag }
  highlights['@tag.html'] = { fg = cyberpunk.lsp.html_tag }
  set_highlight(highlights, {
    '@lsp.typemod.class.defaultLibrary.typescript',
    '@lsp.typemod.class.defaultLibrary.typescriptreact',
  }, { fg = cyberpunk.lsp.class })

  highlights['@string.special.url.http'] = { fg = cyberpunk.lsp.string, underline = true, italic = true }
  highlights['@function.method.http'] = { fg = cyberpunk.lsp.keyword_purple }
  highlights['@constant.http'] = { fg = cyberpunk.lsp.enum }
  highlights['@string.http'] = { fg = cyberpunk.core.bright_green }

  highlights['@markup.raw.block.markdown'] = { fg = cyberpunk.core.green }
  highlights['@markup.heading.2.markdown'] = { fg = cyberpunk.core.magenta }
  highlights['@markup.heading.3.markdown'] = { fg = cyberpunk.core.orange }
  highlights['@markup.heading.4.markdown'] = { fg = cyberpunk.lsp.property }
  highlights['@markup.heading.5.markdown'] = { fg = cyberpunk.core.blue }
  highlights['@markup.raw.markdown_inline'] = {
    bg = cyberpunk.core.dark_bg,
    fg = cyberpunk.core.neon_blue,
  }
  highlights['@markup.list.markdown'] = { fg = cyberpunk.lsp.enum }
  highlights['@markup.strong'] = {
    fg = cyberpunk.lsp.bold,
    bold = true,
  }

  highlights['cssCustomProp'] = { fg = cyberpunk.lsp.property }
  highlights['cssStringQQ'] = { fg = cyberpunk.lsp.string }
  highlights['cssPseudoClassId'] = { fg = cyberpunk.lsp.class }

  --- terraform
  reset_lsp_highlights(highlights, 'terraform', {
    '@lsp.type.type',
    '@lsp.type.enumMember',
    '@lsp.type.keyword',
  })
  -- highlights['@lsp.typemod.enumMember.defaultLibrary.terraform'] = { fg = cyberpunk.lsp.class }

  --- rust
  highlights['@lsp.typemod.method.defaultLibrary.rust'] = { fg = cyberpunk.lsp.func }
  highlights['@lsp.type.macro.rust'] = { fg = cyberpunk.core.orange }
  highlights['@lsp.typemod.enumMember.library.rust'] = { fg = cyberpunk.lsp.property }

  set_highlight(highlights, { '@module.rust', '@lsp.type.namespace.rust' }, { fg = cyberpunk.lsp.weirdbrown })
end

local M = {}

function M.apply_colors(colors)
  colors['border_highlight'] = cyberpunk.core.neon_green
  colors['hint'] = cyberpunk.core.hint
  colors['bg_statusline'] = '' -- to remove avante header lines unser of other side effects
end

function M.apply_highlight(highlights, colors)
  set_nvim_core(highlights, colors)

  set_jojo_git(highlights)

  set_noice_plugin(highlights)
  set_telescope_plugin(highlights)
  set_neotree_plugin(highlights)
  set_mini_plugin(highlights)
  set_arrow_plugin(highlights)
  set_grugfar_plugin(highlights)
  set_lazygit_plugin(highlights)
  set_blink_plugin(highlights)
  set_snacks_plugin(highlights)
  set_avante_plugin(highlights)
  set_mcphub_plugin(highlights)
  set_markview_plugin(highlights)

  set_icon_highlights(highlights)
  set_lsp_highlights(highlights)
end

return M
