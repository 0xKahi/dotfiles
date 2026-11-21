---@class jojo.key
local M = {}

M.prefix_key = 'ctrl+b'

--- Build a prefixed key sequence, e.g. prefix('z') -> 'ctrl+b>z'
---@param key string
---@return string
function M.prefix(key)
  return M.prefix_key .. '>' .. key
end

---@alias jojo.key.mode_key fun(key: string): string

---@class jojo.key.mode_opts
---@field exclusive? boolean ignore keys the mode doesn't bind
---@field once? boolean leave the mode automatically after one shortcut
---@field enter? string[] keys that enter the mode
---@field exit? string[] keys inside the mode that leave it (Escape always works)
---@field setup? fun(mode_key: jojo.key.mode_key, name: string) bind the mode's keys

--- Define a key mode and its bindings in one place.
--- `mode_key('h')` -> 'name/h', for binding keys inside the mode.
---@param name string lowercase letters, digits, `_` and `-` only
---@param opts? jojo.key.mode_opts
---@return jojo.key.mode_key
function M.create_mode(name, opts)
  opts = opts or {}

  ---@type jojo.key.mode_key
  local function mode_key(key)
    return name .. '/' .. key
  end

  if opts.exclusive ~= nil then
    rex.mode(name, { exclusive = opts.exclusive })
  end

  for _, key in ipairs(opts.enter or {}) do
    rex.bind(key, 'client.mode.enter', { name = name, once = opts.once })
  end

  for _, key in ipairs(opts.exit or {}) do
    rex.bind(mode_key(key), 'client.mode.exit')
  end

  if opts.setup then
    opts.setup(mode_key, name)
  end

  return mode_key
end

return M
