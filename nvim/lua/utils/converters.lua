local M = {}

local cryptoStorageDecimals = 17

function M.pxToRem(px)
  if type(px) ~= 'number' then
    return nil, 'Input must be a number'
  end
  return px / 16
end

function M.remToPx(rem)
  if type(rem) ~= 'number' then
    return nil, 'Input must be a number'
  end
  return rem * 16
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

function M.cryptoBN(bn)
  if type(bn) ~= 'number' then
    return nil, 'Input must be a number'
  end
  return bn / (10 ^ cryptoStorageDecimals)
end

return M
