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

local terminal = 'com.superlogical.terminal'

--- Call a terminal block method, returning its result table or nil on error
---@param method string
---@param block_id? string
---@return table?
local function terminal_call(method, block_id)
  local ok, res = pcall(rex.block.call, terminal, method, { block_id = block_id })
  return ok and type(res) == 'table' and res or nil
end

--- Working directory of a terminal block, as a plain path.
--- Prefers the directory the shell reported via OSC 7 (`file://host/path`, stripped to `/path`),
--- falling back to the foreground process's actual cwd for shells that don't report it.
---@param block_id? string defaults to the current block
---@return string? cwd nil when it can't be found or the block isn't a terminal
function M.get_cwd(block_id)
  local reported = terminal_call('pwd', block_id)
  local pwd = reported and reported.pwd
  if pwd and pwd ~= '' then
    return M.url_decode((pwd:gsub('^file://[^/]*', '')))
  end

  local proc = terminal_call('process', block_id)
  if not proc then
    return nil
  end
  local foreground = proc.foreground and proc.foreground.cwd
  local shell = proc.ancestors and proc.ancestors[1] and proc.ancestors[1].cwd
  return foreground or shell
end

return M
