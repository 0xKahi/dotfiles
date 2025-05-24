local snippetUtils = require('snippets.libs.util')
local M = {}

local currencyImportSnippet = [[
import { Currency } from '@shuffle/common/enums/currency.enum';
]]

M['󰋺 Currency'] = snippetUtils.simpleSnippetHandler({
  snippet = currencyImportSnippet,
})

return M
