---@meta _

---@class jojo
---@field key jojo.key
---@field utils jojo.utils
---@field float jojo.float
---@field rex jojo.rex
---@field secrets jojo.secrets
---@field store jojo.store

---@class JoJo: jojo
JoJo = {
  key = require('jojo.key'),
  utils = require('jojo.utils'),
  float = require('jojo.float'),
  rex = require('jojo.rex'),
  secrets = require('jojo.secrets'),
}

-- lazily require any other jojo.* module on first access
setmetatable(JoJo, {
  __index = function(t, k)
    t[k] = require('jojo.' .. k)
    return rawget(t, k)
  end,
})

---@alias JoJoStoreKey "shell_path" | "log"

---@class jojo.store
JoJo.store = {
  _cache = {
    shell_path = nil,
    log = nil,
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
