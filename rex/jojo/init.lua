---@meta _

---@class jojo.rex
---@field key jojo.key
---@field ui jojo.ui
---@field utils jojo.utils
---@field float jojo.float

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

_G.JoJo = JoJo

return JoJo
