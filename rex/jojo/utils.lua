---@class jojo.utils
local M = {}

--- Decode %XX escapes in a URL, e.g. 'My%20Projects' -> 'My Projects'
---@param s string
---@return string
function M.url_decode(s)
  return (s:gsub('%%(%x%x)', function(hex)
    return string.char(tonumber(hex, 16))
  end))
end

--- trims whitespace
---@param s string
---@return string
function M.trim(s)
  return (s:match('^%s*(.-)%s*$'))
end

--- Split text into its non-empty lines, e.g. 'a\n\nb\n' -> { 'a', 'b' }
---@param s string
---@return string[]
function M.split_lines(s)
  local lines = {}
  for line in s:gmatch('[^\r\n]+') do
    lines[#lines + 1] = line
  end
  return lines
end

--- Like pairs(), but iterates in reverse of the order pairs() yields.
--- Rex lists the most recently bound key first, so binding with rpairs keeps a key table in source order.
--- pairs() order isn't guaranteed by Lua; this relies on it matching insertion order for small tables.
---@generic K, V
---@param t table<K, V>
---@return fun(): K, V
function M.rpairs(t)
  local keys = {}
  for k in pairs(t) do
    keys[#keys + 1] = k
  end
  local i = #keys + 1
  return function()
    i = i - 1
    local k = keys[i]
    if k ~= nil then
      return k, t[k]
    end
  end
end

return M
