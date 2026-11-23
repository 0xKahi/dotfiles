---@class jojo.float
local M = {}

M.layout = {
  default = { 0.15, 0.15, 0.7, 0.7 },
  log = { 0.2, 0.35, 0.5, 0.3 },
  popup = { 0.15, 0.375, 0.7, 0.25 }, -- centered 70% x 25%, like tmux `popup -w 70% -h 25%` / `fzf --popup 70%,25%`
}

M.padding = {
  cols = 1, -- left/right gap in terminal columns
  top = 0, -- top gap in terminal rows
  bottom = 1.3, -- bottom gap in terminal rows
}

local fallback_padding = { x = 0.005, top = 0, bottom = 0.015 }

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
        cwd = opts.cwd or JoJo.rex.get_cwd(opts.block_id),
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

--- Return the floating layer containing `block_id`, or nil if the block is tiled or not found.
---@param block_id string
---@return table?
function M.find_layer(block_id)
  local view = rex.session.view({})
  for _, window in ipairs(view.windows or {}) do
    for _, layer in ipairs(window.layers or {}) do
      if layer.kind == 'floating' then
        for _, block in ipairs(layer.blocks or {}) do
          if block.block_id == block_id then
            return layer
          end
        end
      end
    end
  end
  return nil
end

--- List floating layers in the active window (optionally filtered by state).
---@param opts? { state?: 'normal'|'minimized' }
---@return table[] layers
function M.list_layers(opts)
  opts = opts or {}
  local view = rex.session.view({})
  local layers = {}

  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      for _, layer in ipairs(window.layers or {}) do
        if layer.kind == 'floating' then
          local is_minimized = layer.state == 'minimized'
          local matches = opts.state == nil
            or (opts.state == 'minimized' and is_minimized)
            or (opts.state == 'normal' and not is_minimized)
          if matches then
            layers[#layers + 1] = layer
          end
        end
      end
      break
    end
  end

  return layers
end

---@alias jojo.float.snap_target 'left'|'right'|'top'|'bottom'|'center'

---@class jojo.float.padding
---@field cols? number left/right gap in terminal columns
---@field top? number top gap in terminal rows
---@field bottom? number bottom gap in terminal rows

---@class jojo.float.snap_opts
---@field block_id? string terminal block used to convert col/row padding into window fractions
---@field padding? jojo.float.padding defaults to `M.padding`
---@field ref_bounds? number[] original bounds before resizing, used to compute accurate cell-to-window fractions

--- Resolve cell-based padding into [pad_x, pad_top, pad_bottom] window fractions.
---@param bounds number[] [x, y, w, h] fractions of the window
---@param opts? jojo.float.snap_opts
---@return number pad_x, number pad_top, number pad_bottom
function M.get_padding(bounds, opts)
  opts = opts or {}
  local padding = opts.padding or {}
  local cols = padding.cols or M.padding.cols
  local top = padding.top or M.padding.top
  local bottom = padding.bottom or M.padding.bottom
  local w, h = bounds[3], bounds[4]

  local size = JoJo.rex.get_terminal_size(opts.block_id)
  local pad_x = size and (cols * w / size.columns) or fallback_padding.x
  local pad_top = size and (top * h / size.rows) or fallback_padding.top
  local pad_bottom = size and (bottom * h / size.rows) or fallback_padding.bottom
  return pad_x, pad_top, pad_bottom
end

--- Compute bounds snapped to an edge or center while keeping size and the other axis.
---@param bounds number[] [x, y, w, h] fractions of the window
---@param target jojo.float.snap_target
---@param opts? jojo.float.snap_opts
---@return number[] bounds
function M.snap_bounds(bounds, target, opts)
  opts = opts or {}
  local x, y, w, h = bounds[1], bounds[2], bounds[3], bounds[4]
  local pad_x, pad_top, pad_bottom = M.get_padding(opts.ref_bounds or bounds, opts)

  if target == 'left' then
    x = math.min(pad_x, 1 - w)
  elseif target == 'right' then
    x = math.max(0, 1 - w - pad_x)
  elseif target == 'top' then
    y = math.min(pad_top, 1 - h)
  elseif target == 'bottom' then
    y = math.max(0, 1 - h - pad_bottom)
  elseif target == 'center' then
    x = (1 - w) / 2
    y = (1 - h) / 2
  end

  return { x, y, w, h }
end

return M
