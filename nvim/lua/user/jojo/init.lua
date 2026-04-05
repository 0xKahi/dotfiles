-- local jojo = require('user.jojo')
---@meta _

---@class jojo.plugins
---@field treesitter user.jojo.treesitter
---@field utils user.jojo.utils

---@class JoJo: jojo.plugins
JoJo = {
  treesitter = require('user.jojo.treesitter'),
  utils = require('user.jojo.utils'),
}

-- setmetatable(M, {
--   __index = function(t, k)
--     if jojo[k] then
--       return jojo[k]
--     end
--     ---@diagnostic disable-next-line: no-unknown
--     t[k] = require('user.jojo.' .. k)
--     return t[k]
--   end,
-- })

setmetatable(JoJo, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require('user.jojo.' .. k)
    return rawget(t, k)
  end,
})

---@alias JoJoStoreKey "git_base"
JoJo.store = {
  _cache = {
    git_base = nil,
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

-- _G.JoJo = M
