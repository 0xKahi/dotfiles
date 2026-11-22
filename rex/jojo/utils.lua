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

--- trims whitespace
---@param s string
---@return string
function M.trim(s)
  return (s:match('^%s*(.-)%s*$'))
end

--- Split text into its non-empty lines, e.g. 'a\n\nb\n' -> { 'a', 'b' }
---@param s string
---@return string[]
function M.split_lines(s)
  local lines = {}
  for line in s:gmatch('[^\r\n]+') do
    lines[#lines + 1] = line
  end
  return lines
end

--- Like pairs(), but iterates in reverse of the order pairs() yields.
--- Rex lists the most recently bound key first, so binding with rpairs keeps a key table in source order.
--- pairs() order isn't guaranteed by Lua; this relies on it matching insertion order for small tables.
---@generic K, V
---@param t table<K, V>
---@return fun(): K, V
function M.rpairs(t)
  local keys = {}
  for k in pairs(t) do
    keys[#keys + 1] = k
  end
  local i = #keys + 1
  return function()
    i = i - 1
    local k = keys[i]
    if k ~= nil then
      return k, t[k]
    end
  end
end

--- Call a terminal block method, returning its result table or nil on error
---@param method string
---@param block_id? string
---@return table?
local function terminal_call(method, block_id)
  local ok, res = pcall(rex.block.call, 'com.superlogical.terminal', method, { block_id = block_id })
  return ok and type(res) == 'table' and res or nil
end

--- Display title for a block: uses `block.label` when explicitly renamed (not `'shell'`),
--- otherwise falls back to the foreground process name, terminal OSC title, or `'float'`.
---@param block { block_id: string, label?: string }
---@return string
function M.get_title(block)
  if block.label and block.label ~= '' and block.label ~= 'shell' then
    return block.label
  end

  local proc = terminal_call('process', block.block_id)
  local fg = proc and proc.foreground
  if fg and fg.name and fg.name ~= '' then
    return fg.name
  end

  local title = terminal_call('title', block.block_id)
  if title and title.title and title.title ~= '' then
    return title.title
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

return M
