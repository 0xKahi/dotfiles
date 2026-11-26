local home = os.getenv('HOME') or ''

---@param layer table
---@param block_id? string
---@return boolean
local function layer_has_block(layer, block_id)
  if not block_id then
    return false
  end
  for _, block in ipairs(layer.blocks or {}) do
    if block.block_id == block_id then
      return true
    end
  end
  return false
end

---@param block_id? string
---@return string?
local function short_cwd(block_id)
  local cwd = block_id and JoJo.rex.get_cwd(block_id)
  if cwd and home ~= '' and cwd:sub(1, #home) == home then
    cwd = '~' .. cwd:sub(#home + 1)
  end
  return cwd
end

---@param layer table
---@param is_current boolean
---@return table item
local function layer_to_pick_item(layer, is_current)
  local titles = {}
  for _, block in ipairs(layer.blocks or {}) do
    titles[#titles + 1] = JoJo.rex.get_title(block)
  end

  local first_block = layer.blocks and layer.blocks[1]
  local is_minimized = layer.state == 'minimized'
  local base_title = #titles > 0 and table.concat(titles, ' / ') or 'float'

  return {
    id = layer.layer_id,
    title = base_title .. (is_current and ' (current)' or ''),
    subtitle = short_cwd(first_block and first_block.block_id),
    icon = is_minimized and 'package' or 'terminal',
    detail = is_minimized and 'Maximize' or 'Minimize',
  }
end

---@param ctx table
local function toggle_float(ctx)
  local layers = JoJo.float.list_layers()
  if #layers == 0 then
    return
  end

  local target
  local picked = false
  if #layers == 1 then
    target = layers[1]
  else
    local by_id = {}
    local items = {}
    for _, layer in ipairs(layers) do
      by_id[layer.layer_id] = layer
      local is_current = layer_has_block(layer, ctx.block_id)
      local item = layer_to_pick_item(layer, is_current)
      if is_current then
        table.insert(items, 1, item)
      else
        items[#items + 1] = item
      end
    end

    local layer_id = rex.ui.pick({
      title = 'Toggle floating pane',
      placeholder = 'Filter floating panes',
      items = items,
    })
    if not layer_id then
      return
    end
    target = by_id[layer_id]
    picked = true
  end

  if not target then
    return
  end

  local payload = target.state == 'minimized' and { layer_id = target.layer_id, state = 'normal', focus = true }
    or { layer_id = target.layer_id, state = 'minimized' }

  local is_minimizing_current = target.state ~= 'minimized' and layer_has_block(target, ctx.block_id)

  if picked then
    local delay = is_minimizing_current and 0.30 or nil
    JoJo.rex.deferred_api_call(ctx, 'session.set_layer_state', payload, delay)
    return
  end

  if is_minimizing_current then
    rex.client.queue('pane.minimize_floating')
  else
    rex.session.set_layer_state(payload)
  end
end

---@param ctx table
local function open_pane(ctx)
  local view = rex.session.view({})
  local by_id = {}
  local items = {}

  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      for _, layer in ipairs(window.layers or {}) do
        local is_floating = layer.kind == 'floating'
        local is_minimized = is_floating and layer.state == 'minimized'
        local icon = is_minimized and 'package' or (is_floating and 'terminal' or 'globe')
        local detail = is_minimized and 'Minimized' or (is_floating and 'Float' or 'Tiled')

        for _, block in ipairs(layer.blocks or {}) do
          local is_current = block.block_id == ctx.block_id
          by_id[block.block_id] = {
            block_id = block.block_id,
            layer_id = layer.layer_id,
            is_minimized = is_minimized,
          }
          items[#items + 1] = {
            id = block.block_id,
            title = JoJo.rex.get_title(block) .. (is_current and ' (current)' or ''),
            subtitle = short_cwd(block.block_id),
            icon = icon,
            detail = detail,
          }
        end
      end
      break
    end
  end

  if #items == 0 then
    return
  end

  local block_id = rex.ui.pick({
    title = 'Open pane',
    placeholder = 'Filter panes',
    items = items,
  })
  if not block_id then
    return
  end

  local chosen = by_id[block_id]
  if not chosen then
    return
  end

  if chosen.is_minimized then
    JoJo.rex.deferred_api_call(ctx, 'session.set_layer_state', {
      layer_id = chosen.layer_id,
      state = 'normal',
      focus = true,
    })
  else
    JoJo.rex.deferred_api_call(ctx, 'session.focus_block', {
      block_id = chosen.block_id,
    })
  end
end

--- Return a tiled block in the active window to use as a split anchor, or nil if none exists.
---@return string? block_id
local function find_tiled_anchor_id()
  local view = rex.session.view({})
  for _, window in ipairs(view.windows or {}) do
    if window.window_id == view.active_window_id then
      for _, layer in ipairs(window.layers or {}) do
        if layer.kind == 'tiled' then
          local first = layer.blocks and layer.blocks[1]
          if first and first.block_id then
            return first.block_id
          end
        end
      end
      break
    end
  end
  return nil
end

-- prefix + @
rex.bind(JoJo.key.prefix('shift+2'), 'pane.float')
rex.bind(JoJo.key.prefix('o'), function(ctx)
  JoJo.float.create({
    command = { 'pane-mux', 'switch-session' },
    block_id = ctx.block_id,
  })
  return true
end)

local float_mode = 'panemux_float'
JoJo.key.create_mode(float_mode, {
  exclusive = true,
  once = true,
  exit = { 'q' },
  setup = function(mode_key, name)
    local action_keys = {
      h = 'left',
      l = 'right',
      t = 'top',
      b = 'bottom',
      c = 'equalize',
      f = 'focus',
      v = 'tile vsplit',
      s = 'tile stacked',
    }

    rex.action({
      name = name,
      title = 'Panemux Float',
      args = { action = 'string' },
      run = function(ctx, args)
        local layer = ctx.block_id and JoJo.float.find_layer(ctx.block_id)
        if not layer then
          return
        end

        if args.action == action_keys.v or args.action == action_keys.s then
          local anchor_id = find_tiled_anchor_id()
          if anchor_id then
            rex.session.move_block({
              block_id = ctx.block_id,
              anchor_block_id = anchor_id,
              direction = args.action == action_keys.v and 'horizontal' or 'vertical',
            })
          else
            rex.client.queue('pane.float')
          end
          return
        end

        local snap_opts = { block_id = ctx.block_id, ref_bounds = layer.bounds }
        local pad_x, pad_top, pad_bottom = JoJo.float.get_padding(layer.bounds, snap_opts)
        local full_w = math.max(0.1, 1 - 2 * pad_x)
        local full_h = math.max(0.1, 1 - pad_top - pad_bottom)
        local x, y = layer.bounds[1], layer.bounds[2]

        local bounds
        if args.action == action_keys.h then
          bounds = JoJo.float.snap_bounds({ x, pad_top, 0.4, full_h }, 'left', snap_opts)
        elseif args.action == action_keys.l then
          bounds = JoJo.float.snap_bounds({ x, pad_top, 0.4, full_h }, 'right', snap_opts)
        elseif args.action == action_keys.t then
          bounds = JoJo.float.snap_bounds({ pad_x, y, full_w, 0.4 }, 'top', snap_opts)
        elseif args.action == action_keys.b then
          bounds = JoJo.float.snap_bounds({ pad_x, y, full_w, 0.4 }, 'bottom', snap_opts)
        elseif args.action == action_keys.c then
          bounds = { math.min(x, 0.6), math.min(y, 0.5), 0.4, 0.5 }
        elseif args.action == action_keys.f then
          bounds = JoJo.float.snap_bounds({ x, y, 0.8, full_h }, 'center', snap_opts)
          bounds = JoJo.float.snap_bounds(bounds, 'top', snap_opts)
        end

        if bounds then
          rex.session.resize_layer({
            layer_id = layer.layer_id,
            bounds = bounds,
          })
        end
      end,
    })

    for key, action in JoJo.utils.rpairs(action_keys) do
      rex.bind(mode_key(key), name, { action = action })
    end
  end,
})

JoJo.key.create_mode('panemux', {
  exclusive = true,
  once = true,
  enter = { JoJo.key.prefix('a') },
  exit = { 'q' },
  setup = function(mode_key, name)
    local panemux_keys = {
      a = 'action',
      o = 'open',
      t = 'toggle float',
      n = 'new float',
      r = 'rename pane',
    }

    rex.action({
      name = name,
      title = 'Panemux',
      args = { action = 'string' },
      run = function(ctx, args)
        if args.action == panemux_keys.a then
          if ctx.block_id and JoJo.float.find_layer(ctx.block_id) then
            rex.client.queue('client.mode.enter', { name = float_mode, once = true })
          end
          return
        end

        if args.action == panemux_keys.o then
          open_pane(ctx)
          return
        end

        if args.action == panemux_keys.t then
          toggle_float(ctx)
          return
        end

        if args.action == panemux_keys.n then
          JoJo.float.create({
            block_id = ctx.block_id,
          })
          return
        end

        if args.action == panemux_keys.r then
          rex.client.queue('pane.rename')
          return
        end
      end,
    })

    for key, action in JoJo.utils.rpairs(panemux_keys) do
      rex.bind(mode_key(key), name, { action = action })
    end
  end,
})

rex.bind(JoJo.key.prefix('t'), 'panemux', { action = 'toggle float' })
