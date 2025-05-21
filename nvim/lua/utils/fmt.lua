local M = {}

-- formatter command for lua files
function M.luaFormat()
  if vim.bo.filetype ~= 'lua' then
    print('This is not a Lua file. Formatting aborted.')
    return
  end

  vim.lsp.buf.format()
  print('Lua file formatted.')
end

function M.toCamelCase(str)
  -- If string is empty, return empty string
  if str == '' then
    return ''
  end

  -- First, replace common separators with spaces
  local s = str:gsub('[_%-]', ' ')

  -- Handle PascalCase/camelCase by adding space before uppercase letters that follow lowercase
  s = s:gsub('(%l)(%u)', '%1 %2')

  -- Convert the entire string to lowercase
  s = s:lower()

  -- Function to capitalize first letter of a word
  local function capitalize(word)
    return word:sub(1, 1):upper() .. word:sub(2)
  end

  -- Get first word (will be all lowercase)
  local result = s:match('%S+') or ''

  -- Process remaining words (capitalize each)
  for word in s:gmatch('%s+(%S+)') do
    result = result .. capitalize(word)
  end

  return result
end

return M
