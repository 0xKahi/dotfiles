local M = {}

function M.random_selector(tbl)
  if type(tbl) ~= 'table' then
    error('Expected table as argument')
  end

  -- Create an array of keys
  local keys = {}
  for key, _ in pairs(tbl) do
    table.insert(keys, key)
  end

  if #keys == 0 then
    return nil, nil
  end

  local key = keys[math.random(#keys)]
  return tbl[key]
end

-- for printing tables
function M.debug_table(tbl, title)
  -- Convert the table to a string using vim.inspect
  local table_str = vim.inspect(tbl)
  -- Add a title if one was provided
  if title then
    table_str = title .. ':\n' .. table_str
  end
  -- Show the table contents as a notification
  vim.notify(table_str, vim.log.levels.DEBUG)
end

return M
