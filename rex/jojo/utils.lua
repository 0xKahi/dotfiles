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

return M
