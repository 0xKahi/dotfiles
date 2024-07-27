local M = {}

function M.pxToRem(px)
  if type(px) ~= 'number' then
    return nil, 'Input must be a number'
  end
  return px / 16
end

function M.msToSec(ms)
  if type(ms) ~= 'number' then
    return nil, 'Input must be a number'
  end
  return ms / 1000
end

function M.sToMs(s)
  if type(s) ~= 'number' then
    return nil, 'Input must be a number'
  end
  return s * 1000
end

return M
