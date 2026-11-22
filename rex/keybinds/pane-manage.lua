-- prefix + @
rex.bind(JoJo.key.prefix('shift+2'), 'pane.float')

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
  local cwd = block_id and JoJo.utils.get_cwd(block_id)
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
    titles[#titles + 1] = JoJo.utils.get_title(block)
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

  if picked then
    JoJo.utils.deferred_api_call(ctx.session_id, 'session.set_layer_state', payload)
    return
  end

  if target.state ~= 'minimized' and layer_has_block(target, ctx.block_id) then
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
            title = JoJo.utils.get_title(block) .. (is_current and ' (current)' or ''),
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
    JoJo.utils.deferred_api_call(ctx.session_id, 'session.set_layer_state', {
      layer_id = chosen.layer_id,
      state = 'normal',
      focus = true,
    })
  else
    JoJo.utils.deferred_api_call(ctx.session_id, 'session.focus_block', {
      block_id = chosen.block_id,
    })
  end
end

JoJo.key.create_mode('panemux', {
  exclusive = true,
  once = true,
  enter = { JoJo.key.prefix('a') },
  exit = { 'q' },
  setup = function(mode_key, name)
    local panemux_keys = {
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
