---@class user.jojo.treesitter
local M = {}

M._cache = {
  installed = {}, ---@type table<string>
  queries = {}, ---@type table<string,boolean>
}

function M.flush()
  M._cache.installed = {}
  M._cache.queries = {}
end

---@class user.jojo.treesitter.installed
M.installed = {}

function M.installed.refresh()
  M.flush()
  M._cache.installed = vim
    .iter(vim.api.nvim_get_runtime_file('parser/*', true))
    :map(function(path)
      return path:match('([^/\\]+)%.[^.]+$')
    end)
    :totable()
end
---@param fresh? boolean
function M.installed.get(fresh)
  if fresh then
    M.installed.refresh()
  end
  return M._cache.installed
end

---@param lang string
function M.installed.have(lang)
  if type(M.installed.get()[lang]) == 'nil' then
    return false
  end
  return true
end

---@param lang string
function M.installed.set(lang)
  if not M.installed.have(lang) then
    table.insert(M._cache.installed, lang)
  end
end

---@class user.jojo.treesitter.query
M.query = {}

---@param lang string?
---@param query string
function M.query.have(lang, query)
  if not lang then
    return false
  end
  local key = lang .. ':' .. query
  if M._cache.queries[key] == nil then
    M._cache.queries[key] = vim.treesitter.query.get(lang, query) ~= nil
  end
  return M._cache.queries[key]
end

return M
