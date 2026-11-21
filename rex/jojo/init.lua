---@meta _

---@class jojo.rex
---@field key jojo.key
---@field ui jojo.ui

---@class JoJo: jojo.rex
JoJo = {
  key = require('jojo.key'),
  ui = require('jojo.ui'),
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
