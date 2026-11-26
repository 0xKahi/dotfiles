--- Toggle in and out of a "scratch" session with one key.
---
--- ```lua
--- require('extensions.session-pin').setup({ key = 'cmd+p', session_name = 'my_session' })
--- ```
---
--- Pressing the key from any session switches to `session_name` (creating it if missing).
--- Pressing it again while in `session_name` switches back to the session you came from.
--- Also runnable as an action: `rex do session_pin session_name=my_session`.
---@class session_pin
local M = {}

---@class session_pin.opts
---@field key? string key that toggles the session, e.g. 'cmd+p'
---@field session_name string label of the session to toggle into
---@field cwd? string working directory for the session's first terminal, defaults to $HOME

---@type table<string, session_pin.opts> per session_name
local configs = {}

--- Session we came from, per server and toggled session_name. Lost on config reload.
---@type table<string, string>
local previous = {}

---@param ctx table action context
---@param name string
---@return string
local function previous_key(ctx, name)
  return (ctx.server or '') .. '\0' .. name
end

local registered = false

---@return { session_id: string, label: string }[]
local function list_sessions()
  local res, err = rex.call('session.list')
  if not res then
    rex.log('error', 'session-pin: session.list failed: ' .. tostring(err))
    return {}
  end
  return res.sessions or {}
end

---@param sessions { session_id: string, label: string }[]
---@param pred fun(s: { session_id: string, label: string }): boolean
---@return string? session_id
local function find_session(sessions, pred)
  for _, s in ipairs(sessions) do
    if pred(s) then
      return s.session_id
    end
  end
end

---@param opts session_pin.opts
---@return string? session_id
local function create_session(opts)
  local res, err = rex.call('session.create', {
    label = opts.session_name,
    initial_windows = {
      {
        layout = rex.layout.block({
          flavor = 'com.superlogical.terminal.shell',
          options = { cwd = opts.cwd or os.getenv('HOME') },
        }),
      },
    },
  })
  if not res then
    rex.log('error', 'session-pin: could not create session ' .. opts.session_name .. ': ' .. tostring(err))
    return nil
  end
  return res.session_id
end

--- Switch the app to a session on the host the action targets (local or remote).
--- Needs Remote Control turned on in the app when on a remote host, see `JoJo.rex.client_do`.
---@param ctx table action context
---@param session_id string
local function select_session(ctx, session_id)
  JoJo.rex.client_do(ctx, 'session.select', { session_id = session_id })
end

---@param ctx table action context
---@param args { session_name?: string }
local function toggle(ctx, args)
  local name = args.session_name
  if not name then
    -- with a single setup() the name can be left out, e.g. from the command palette
    local only
    for n in pairs(configs) do
      if only then
        only = nil
        break
      end
      only = n
    end
    name = only
  end
  if not name or name == '' then
    rex.log('error', 'session-pin: session_name is required')
    return
  end

  local opts = configs[name] or { session_name = name }
  local sessions = list_sessions()
  local target_id = find_session(sessions, function(s)
    return s.label == name
  end)

  -- in the toggle session: go back where we came from
  if target_id and ctx.session_id == target_id then
    local prev_id = previous[previous_key(ctx, name)]
    local prev_alive = prev_id and find_session(sessions, function(s)
      return s.session_id == prev_id
    end)
    if prev_alive then
      select_session(ctx, prev_id)
    else
      -- no remembered session (config reloaded, or it was closed): let the app pick the previous one
      rex.client.queue('session.previous')
    end
    return
  end

  -- anywhere else: remember this session and switch to the toggle session
  target_id = target_id or create_session(opts)
  if not target_id then
    return
  end
  if ctx.session_id then
    previous[previous_key(ctx, name)] = ctx.session_id
  end
  select_session(ctx, target_id)
end

--- Register the `session_pin` action and bind `opts.key` to it. Can be called once per session_name.
---@param opts session_pin.opts
function M.setup(opts)
  assert(opts and opts.session_name and opts.session_name ~= '', 'session-pin: session_name is required')
  configs[opts.session_name] = opts

  if not registered then
    registered = true
    rex.action({
      name = 'session_pin',
      title = 'Session Pin: Toggle',
      description = 'Switch to a session by name (creating it if needed), or back to the previous one if already there. '
        .. 'Usage: rex do session_pin session_name=NAME',
      category = 'Sessions',
      args = { session_name = 'string?' },
      run = toggle,
    })
  end

  if opts.key then
    rex.bind(opts.key, 'session_pin', { session_name = opts.session_name })
  end
end

return M
