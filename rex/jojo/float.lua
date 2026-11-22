---@class jojo.float
local M = {}

M.layout = {
  default = { 0.1, 0.1, 0.8, 0.8 },
  log = { 0.2, 0.35, 0.5, 0.3 },
  popup = { 0.15, 0.375, 0.7, 0.25 }, -- centered 70% x 25%, like tmux `popup -w 70% -h 25%` / `fzf --popup 70%,25%`
}

---@class jojo.float.opts
---@field command? string[] program and its arguments, e.g. { 'lazygit' }; omit for an interactive shell
---@field cwd? string working directory, defaults to the anchor block's cwd
---@field block_id? string block whose cwd to inherit, defaults to the current block
---@field bounds? number[] [x, y, w, h] fractions of the window, defaults to centered 80%
---@field interactive? boolean run command through a shell that also reads ~/.zshrc, so it sees what your terminals see (e.g. FZF_DEFAULT_OPTS)

--- Open a floating pane
---@param opts? jojo.float.opts
function M.create(opts)
  opts = opts or {}
  return rex.session.new_layer({
    bounds = opts.bounds or M.layout.default,
    focus = true,
    layout = rex.layout.block({
      flavor = 'com.superlogical.terminal.shell',
      options = {
        command = opts.command,
        cwd = opts.cwd or JoJo.utils.get_cwd(opts.block_id),
        interactive = opts.interactive,
      },
    }),
  })
end

---@alias jojo.float.log_level 'error'|'warn'|'info'

---@class jojo.float.log_opts
---@field message string[] lines to show, one per line
---@field title? string heading above the message, defaults to the level, e.g. 'error'
---@field block_id? string block whose cwd to inherit, defaults to the current block
---@field bounds? number[] [x, y, w, h] fractions of the window, defaults to a small centered pane

local log_colors = { error = '31', warn = '33', info = '34' }
local log_script = [=[
title=$1 color=$2
shift 2
printf '\033[1;%sm%s\033[0m\n\n' "$color" "$title"
printf '%s\n' "$@"
printf '\n\033[2mpress q to close\033[0m'
while IFS= read -rsn1 key; do [[ $key == q ]] && break; done
]=]

--- Show a message, such as an error, in a small floating pane that stays open until q is pressed.
---@param level jojo.float.log_level colours the heading
---@param opts jojo.float.log_opts
function M.create_log(level, opts)
  local command = { 'bash', '-c', log_script, 'jojo-log', opts.title or level, log_colors[level] }
  for _, line in ipairs(opts.message) do
    command[#command + 1] = line
  end

  return M.create({
    command = command,
    block_id = opts.block_id,
    bounds = opts.bounds or M.layout.log,
  })
end

return M
