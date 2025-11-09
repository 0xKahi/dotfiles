---@alias GlobalStateKey "git_base"

Global = {}

Global.state = {
  git_base = nil,
}

---@param prop GlobalStateKey The state property name
---@param value any The value to set
function Global:set(prop, value)
  self.state[prop] = value
end

---@param prop GlobalStateKey The state property name
---@return any value The value stored in state
function Global:get(prop)
  return self.state[prop]
end
