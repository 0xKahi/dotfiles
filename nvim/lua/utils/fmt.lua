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

function M.toPascalCase(str)
  -- If string is empty, return empty string
  if str == '' then
    return ''
  end

  -- Convert to camelCase first
  local camelCaseStr = M.toCamelCase(str)

  -- Capitalize the first letter
  return camelCaseStr:sub(1, 1):upper() .. camelCaseStr:sub(2)
end

function M.toSnakeCase(str)
  -- If string is empty, return empty string
  if str == '' then
    return ''
  end

  -- Convert PascalCase/camelCase to snake_case by adding underscore before uppercase letters
  -- and then converting the whole string to lowercase.
  -- Example: "PascalCase" -> "pascal_case", "camelCase" -> "camel_case"
  local s = str:gsub('(%l)(%u)', '%1_%2')

  -- Replace spaces, hyphens, and multiple underscores with a single underscore
  s = s:gsub('[%s%-]+', '_') -- Replace spaces and hyphens with single underscore
  s = s:gsub('__+', '_') -- Replace multiple underscores with single underscore

  -- Convert the entire string to lowercase
  s = s:lower()

  return s
end

function M.toKebabCase(str)
  -- If string is empty, return empty string
  if str == '' then
    return ''
  end

  -- Convert PascalCase/camelCase to kebab-case by adding hyphen before uppercase letters
  -- and then converting the whole string to lowercase.
  -- Example: "PascalCase" -> "pascal-case", "camelCase" -> "camel-case"
  local s = str:gsub('(%l)(%u)', '%1-%2')

  -- Replace spaces, underscores, and multiple hyphens with a single hyphen
  s = s:gsub('[%s_]+', '-') -- Replace spaces and underscores with single hyphen
  s = s:gsub('[-]+', '-') -- Replace multiple hyphens with single hyphen

  -- Convert the entire string to lowercase
  s = s:lower()

  return s
end

function M.toUpperCase(str)
  -- If string is empty, return empty string
  if str == '' then
    return ''
  end

  -- Convert the entire string to uppercase
  return str:upper()
end

return M
