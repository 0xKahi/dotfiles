--- Pick a named batch of shell commands and run each one in its own pane of a floating layer.
---
--- ```lua
--- require('extensions.batch-commands').setup({
---   key = JoJo.key.prefix('u'),
---   commands = {
---     work = {
---       description = 'update work repos',
---       batch = {
---         { 'cd', '/path/to/work', '&&', 'git', 'pull' },
---         'cd /path/to/work2 && git pull',
---       },
---     },
---   },
--- })
--- ```
---
--- Each batch entry is shell code: a list of words joined with spaces, or a plain string.
--- Words are not quoted, so `&&`, `|`, `~` and `$VAR` work as in a shell.
--- The float is snapped to the right edge (40% wide, full height), with one stacked pane per command.
--- A pane closes as soon as its command succeeds; on failure it stays open, showing the exit code, until a key is pressed.
--- Also runnable as an action: `rex do batch_commands name=work`.
---@class batch_commands
local M = {}

---@alias batch_commands.command string|string[]

---@class batch_commands.group
---@field batch batch_commands.command[] commands to run, one pane each
---@field description? string shown in the picker
---@field cwd? string working directory for every command, defaults to the current pane's cwd

---@class batch_commands.opts
---@field key? string key that opens the picker, e.g. JoJo.key.prefix('u')
---@field commands table<string, batch_commands.group>

---@type table<string, batch_commands.group>
local groups = {}

local registered = false

-- Runs "$1" as shell code. A clean exit closes the pane; a failure keeps it open until a key is pressed.
local runner = [=[
printf '\033]2;%s\007' "$1"
printf '\033[1;34m$ %s\033[0m\n\n' "$1"
eval "$1"
rc=$?
[ "$rc" -eq 0 ] && exit 0
printf '\n\033[1;31mexit %s\033[0m \033[2m- press any key to close\033[0m' "$rc"
read -rsn1 _
exit "$rc"
]=]

---@param command batch_commands.command
---@return string
local function to_shell(command)
  if type(command) == 'table' then
    return table.concat(command, ' ')
  end
  return tostring(command)
end

--- Window-relative rect [x, y, w, h] of a block in the active window, or nil if not found.
---@param block_id? string
---@return number[]?
local function find_block_rect(block_id)
  if not block_id then
    return nil
  end

  local function walk(node)
    if not node then
      return nil
    end
    if node.block_id == block_id then
      return node.rect
    end
    if node.split then
      return walk(node.split.before) or walk(node.split.after)
    end
  end

  local view = rex.session.view({})
  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      for _, layer in ipairs(window.layers or {}) do
        local rect = walk(layer.layout)
        if rect then
          return rect
        end
      end
      break
    end
  end
end

--- Same sizing as the `right` snap in keybinds/pane-manage.lua: 40% wide, full height, snapped right.
---@param ctx table action context
---@return number[] bounds
local function float_bounds(ctx)
  local ref = find_block_rect(ctx.block_id) or { 0, 0, 1, 1 }
  local snap_opts = { block_id = ctx.block_id, ref_bounds = ref }
  local _, pad_top, pad_bottom = JoJo.float.get_padding(ref, snap_opts)
  local full_h = math.max(0.1, 1 - pad_top - pad_bottom)
  return JoJo.float.snap_bounds({ 0, pad_top, 0.4, full_h }, 'right', snap_opts)
end

--- One pane per command, stacked top to bottom with equal heights.
---@param commands batch_commands.command[]
---@param cwd? string
---@return table layout
local function build_layout(commands, cwd)
  local blocks = {}
  for i, command in ipairs(commands) do
    local shell = to_shell(command)
    blocks[i] = rex.layout.block({
      flavor = 'com.superlogical.terminal.shell',
      options = {
        command = { 'bash', '-c', runner, 'batch-commands', shell },
        cwd = cwd,
        interactive = true,
      },
    })
  end

  local layout = blocks[#blocks]
  for i = #blocks - 1, 1, -1 do
    layout = rex.layout.vertical(1 / (#blocks - i + 1), blocks[i], layout)
  end
  return layout
end

---@param ctx table action context
---@param name string
local function run_group(ctx, name)
  local group = groups[name]
  if not group then
    JoJo.float.create_log('error', {
      title = 'batch-commands',
      message = { ('no batch named %q'):format(name) },
      block_id = ctx.block_id,
    })
    return
  end
  if not group.batch or #group.batch == 0 then
    return
  end

  local res, err = rex.session.new_layer({
    bounds = float_bounds(ctx),
    focus = true,
    layout = build_layout(group.batch, group.cwd or JoJo.rex.get_cwd(ctx.block_id)),
  })
  if not res then
    JoJo.float.create_log('error', {
      title = 'batch-commands: ' .. name .. ' failed',
      message = { tostring(err) },
      block_id = ctx.block_id,
    })
    return
  end

  -- closing the picker gives focus back to the previous pane, so refocus the float afterwards
  local first = res.block_ids and res.block_ids[1]
  if first then
    JoJo.rex.deferred_api_call(ctx, 'session.focus_block', { block_id = first })
  end
end

---@param ctx table action context
---@param args { name?: string }
local function run(ctx, args)
  if args.name and args.name ~= '' then
    run_group(ctx, args.name)
    return
  end

  local names = {}
  for name in pairs(groups) do
    names[#names + 1] = name
  end
  table.sort(names)
  if #names == 0 then
    return
  end

  local items = {}
  for _, name in JoJo.utils.rpairs(names) do
    local group = groups[name]
    local count = #(group.batch or {})
    items[#items + 1] = {
      id = name,
      title = name,
      subtitle = group.description,
      icon = 'code',
      detail = count .. (count == 1 and ' command' or ' commands'),
    }
  end

  local name = rex.ui.pick({
    title = 'Batch commands',
    placeholder = 'Filter batches',
    items = items,
  })
  if name then
    run_group(ctx, name)
  end
end

--- Register the `batch_commands` action and bind `opts.key` to its picker.
---@param opts batch_commands.opts
function M.setup(opts)
  assert(opts and type(opts.commands) == 'table', 'batch-commands: commands is required')
  for name, group in pairs(opts.commands) do
    assert(type(group.batch) == 'table', ('batch-commands: %s.batch must be a list'):format(name))
    groups[name] = group
  end

  if not registered then
    registered = true
    rex.action({
      name = 'batch_commands',
      title = 'Batch Commands: Run',
      description = 'Pick a batch of commands and run each in its own pane of a floating layer. '
        .. 'Usage: rex do batch_commands [name=NAME]',
      category = 'Panes',
      args = { name = 'string?' },
      run = run,
    })
  end

  if opts.key then
    rex.bind(opts.key, 'batch_commands')
  end
end

return M
