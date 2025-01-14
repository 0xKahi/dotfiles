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

return M
