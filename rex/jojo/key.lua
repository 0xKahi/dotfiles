---@class jojo.key
local M = {}

M.prefix_key = 'ctrl+b'

--- Build a prefixed key sequence, e.g. prefix('z') -> 'ctrl+b>z'
---@param key string
---@return string
function M.prefix(key)
  return M.prefix_key .. '>' .. key
end

return M
