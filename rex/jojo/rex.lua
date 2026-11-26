--- Helpers for Rex terminal blocks: titles, cwd, size, and calling the server from a shell.
---@class jojo.rex
local M = {}

--- Call a terminal block method, returning its result table or nil on error
---@param method string
---@param block_id? string
---@return table?
local function terminal_call(method, block_id)
  local ok, res = pcall(rex.block.call, 'com.superlogical.terminal', method, { block_id = block_id })
  return ok and type(res) == 'table' and res or nil
end

local shells = { zsh = true, bash = true, fish = true, sh = true, nu = true, dash = true, ksh = true }

--- Program name per Rex's process schema: first non-empty of `script`, `argv0`, `name`,
--- stripped to its basename without a leading login-shell `-`.
---@param p? table process record from the terminal `process` method
---@return string?
local function process_name(p)
  if not p then
    return nil
  end
  local name = (p.script and p.script ~= '' and p.script) or (p.argv0 and p.argv0 ~= '' and p.argv0) or p.name
  name = name and name:gsub('^%-', ''):match('([^/]+)$')
  return name ~= '' and name or nil
end

--- Display title for a block: uses `block.label` when explicitly renamed (not `'shell'`),
--- otherwise the terminal OSC title when set, falling back to a generated title (`program · dir`
--- while a program runs, `dir` at an idle shell), then `'float'`.
---@param block { block_id: string, label?: string }
---@return string
function M.get_title(block)
  if block.label and block.label ~= '' and block.label ~= 'shell' then
    return block.label
  end

  local title = terminal_call('title', block.block_id)
  if title and title.title and title.title ~= '' then
    return title.title
  end

  local proc = terminal_call('process', block.block_id)
  local fg = proc and proc.foreground
  local parent = proc and proc.ancestors and proc.ancestors[1]
  local cwd = M.get_cwd(block.block_id)
  local dir = cwd and (cwd == (proc and proc.home) and '~' or cwd:match('([^/]+)/?$') or cwd)

  local program = process_name(fg)
  -- At a prompt the shell itself is foreground, directly under the terminal's root process (login or itself)
  local root_pid = proc and proc.child and proc.child.pid
  local at_root = not parent or parent.pid == root_pid or (fg and fg.pid == root_pid)
  local is_idle_shell = at_root and program and shells[program]
  if program and not is_idle_shell then
    return dir and (program .. ' · ' .. dir) or program
  end
  if dir then
    return dir
  end

  return (block.label and block.label ~= '' and block.label) or 'float'
end

--- Terminal grid and cell pixel dimensions of a terminal block.
---@param block_id? string defaults to the current block
---@return { columns: number, rows: number, cell_width_px: number, cell_height_px: number }?
function M.get_terminal_size(block_id)
  local size = terminal_call('size', block_id)
  if size and size.columns and size.rows and size.columns > 0 and size.rows > 0 then
    return size
  end
  return nil
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
    return JoJo.utils.url_decode((pwd:gsub('^file://[^/]*', '')))
  end

  local proc = terminal_call('process', block_id)
  if not proc then
    return nil
  end
  local foreground = proc.foreground and proc.foreground.cwd
  local shell = proc.ancestors and proc.ancestors[1] and proc.ancestors[1].cwd
  return foreground or shell
end

--- Folder holding the `rex` CLI. Rex sets REX_BIN_DIR in terminals but not on the server itself.
M.rex_bin_dir = os.getenv('REX_BIN_DIR')
  or (
    os.getenv('HOME')
    .. '/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS'
  )

--- PATH as your interactive login shell sees it (.zshenv, .zprofile and .zshrc), plus the `rex` CLI.
--- The Rex server runs with launchd's bare PATH, so commands from `rex.exec` can't find Homebrew tools
--- or `rex` without this. Resolved once by starting `$SHELL -lic` and cached in `JoJo.store` under `shell_path`.
---@param refresh? boolean re-run the shell instead of using the cached value
---@return string path
function M.get_shell_path(refresh)
  local cached = JoJo.store:get('shell_path')
  if cached ~= nil and not refresh then
    return cached
  end

  local fallback = table.concat({ '/opt/homebrew/bin', M.rex_bin_dir, os.getenv('PATH') or '/usr/bin:/bin' }, ':')
  local marker = '__JOJO_PATH__'
  -- interactive startup can print escape sequences, so fence PATH between markers
  local result, err = rex.exec(
    { os.getenv('SHELL') or '/bin/zsh', '-lic', 'print -r -- "' .. marker .. '${PATH}' .. marker .. '"' },
    { env = { REX_BIN_DIR = M.rex_bin_dir }, stdin = '', stderr = false, timeout = 5 }
  )

  local path = result and result.ok and result.stdout:match(marker .. '(.-)' .. marker)
  if not path or path == '' then
    rex.log(
      'warn',
      'jojo: could not read shell PATH (' .. tostring(err or (result and result.code)) .. '), using fallback'
    )
    return fallback
  end

  if not path:find(M.rex_bin_dir, 1, true) then
    path = M.rex_bin_dir .. ':' .. path
  end

  JoJo.store:set('shell_path', path)
  return path
end

--- Run a server API call detached after a short delay.
--- Workaround for Rex macOS bug (#1573463677779181669): closing the rex.ui.pick palette
--- restores focus to the pre-palette pane after the action returns, undoing focus changes
--- and reopening a just-minimized focused float.
---@param session_id string
---@param method string server API method name, e.g. 'session.focus_block'
---@param payload table JSON-serializable arguments table
---@param delay? number seconds to wait before calling, defaults to 0.15
function M.deferred_api_call(session_id, method, payload, delay)
  rex.exec.start({
    '/bin/sh',
    '-c',
    'sleep "$1" && "$2" api call -s "$3" "$4" "$5"',
    'jojo-deferred-api',
    tostring(delay or 0.15),
    M.rex_bin_dir .. '/rex',
    session_id,
    method,
    rex.json.encode(payload),
  }, { detach = true })
end

--- This Mac app's client label (Settings > General > Client Info).
--- Read from the app's defaults, since actions run on the home server on the same Mac.
---@return string? label
function M.app_label()
  local r = rex.exec({ 'defaults', 'read', 'com.superlogical.rex', 'rex.client.label' })
  if r and r.ok then
    local label = r.stdout:gsub('%s+$', '')
    if label ~= '' then
      return label
    end
  end
end

--- This app's client id on the remote server `ctx.server`. `ctx.client_id` is its id on the home server.
--- `rex.call` goes to `ctx.server` inside an action for a remote session, so `client.list` lists the remote's clients.
---@param ctx table action context
---@return string? client_id
---@return string? err
function M.remote_client_id(ctx)
  local label = M.app_label()
  if not label then
    return nil, 'set a client label in Settings > General > Client Info'
  end
  local res, err = rex.call('client.list')
  if not res then
    return nil, 'client.list failed: ' .. tostring(err)
  end
  for _, c in ipairs(res.clients or {}) do
    if c.info and c.info.kind == 'app' and c.info.label == label then
      return c.client_id
    end
  end
  return nil, ('app %q is not connected to %s'):format(label, ctx.server)
end

--- `rex.client.queue` that also works when the action targets a remote host.
--- Actions for a remote session run on the home server with `ctx.server` set, but queued client actions
--- resolve session/window ids against the home server ("not found on this server"). On a remote host this asks
--- the app's connection on that server via `client.perform` instead, which runs immediately rather than after
--- `run` returns. The remote path needs Remote Control turned on in the app.
--- Only needed for client actions whose args carry server-side ids, e.g. `session.select`.
---@param ctx table action context
---@param action string client action, e.g. 'session.select'
---@param args? table
function M.client_do(ctx, action, args)
  if not ctx.server then
    rex.client.queue(action, args)
    return
  end
  local client_id, err = M.remote_client_id(ctx)
  if not client_id then
    error('jojo: ' .. err, 0)
  end
  local _, perr = rex.call('client.perform', {
    client_id = client_id,
    action = action,
    args = args,
    timeout_ms = 5000,
  })
  if perr then
    error(('jojo: %s on %s failed: %s'):format(action, ctx.server, tostring(perr)), 0)
  end
end

return M
