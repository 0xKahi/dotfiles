---@meta _

---@class jojo.rex
---@field key jojo.key
---@field ui jojo.ui
---@field utils jojo.utils
---@field float jojo.float
---@field store jojo.store

---@class JoJo: jojo.rex
JoJo = {
  key = require('jojo.key'),
  ui = require('jojo.ui'),
  utils = require('jojo.utils'),
  float = require('jojo.float'),
}

-- lazily require any other jojo.* module on first access
setmetatable(JoJo, {
  __index = function(t, k)
    t[k] = require('jojo.' .. k)
    return rawget(t, k)
  end,
})

---@alias JoJoStoreKey "shell_path"

---@class jojo.store
JoJo.store = {
  _cache = {
    shell_path = nil,
  },

  ---@param prop JoJoStoreKey The state property name
  get = function(self, prop)
    return self._cache[prop]
  end,

  ---@param prop JoJoStoreKey The state property name
  ---@param value any The value to set
  set = function(self, prop, value)
    self._cache[prop] = value
  end,
}

_G.JoJo = JoJo

return JoJo
