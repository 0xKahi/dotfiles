local M = {}

function M.getMapping(mode, lhs)
  if not mode or not lhs then
    return 'Invalid arguments'
  end

  local mapping = vim.fn.maparg(lhs, mode, false, true)

  if type(mapping) == 'string' then
    return mapping ~= '' and mapping or 'Mapping not found'
  elseif type(mapping) == 'table' then
    return not vim.tbl_isempty(mapping) and vim.inspect(mapping) or 'Mapping not found'
  else
    return 'Unexpected result type'
  end
end

return M
