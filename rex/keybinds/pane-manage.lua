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

---@param layer table
---@param is_current boolean
---@return table item
local function layer_to_pick_item(layer, is_current)
  local titles = {}
  for _, block in ipairs(layer.blocks or {}) do
    titles[#titles + 1] = JoJo.utils.get_title(block)
  end

  local first_block = layer.blocks and layer.blocks[1]
  local cwd = first_block and JoJo.utils.get_cwd(first_block.block_id)
  if cwd and home ~= '' and cwd:sub(1, #home) == home then
    cwd = '~' .. cwd:sub(#home + 1)
  end

  local is_minimized = layer.state == 'minimized'
  local base_title = #titles > 0 and table.concat(titles, ' / ') or 'float'

  return {
    id = layer.layer_id,
    title = base_title .. (is_current and ' (current)' or ''),
    subtitle = cwd,
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
    -- Workaround for Rex macOS bug (#1573463677779181669): closing the rex.ui.pick palette
    -- restores focus to the pre-palette pane after the action returns, undoing focus changes
    -- and reopening a just-minimized focused float. Run detached after a short delay so the
    -- action returns and the palette finishes closing first.
    rex.exec.start({
      '/bin/sh',
      '-c',
      'sleep 0.15 && "$1" api call -s "$2" session.set_layer_state "$3"',
      'jojo-toggle-float',
      JoJo.utils.rex_bin_dir .. '/rex',
      ctx.session_id,
      rex.json.encode(payload),
    }, { detach = true })
    return
  end

  if target.state ~= 'minimized' and layer_has_block(target, ctx.block_id) then
    rex.client.queue('pane.minimize_floating')
  else
    rex.session.set_layer_state(payload)
  end
end

JoJo.key.create_mode('panemux', {
  exclusive = true,
  once = true,
  enter = { JoJo.key.prefix('a') },
  exit = { 'q' },
  setup = function(mode_key, name)
    local panemux_keys = {
      t = 'toggle float',
      n = 'new float',
      r = 'rename pane',
    }

    rex.action({
      name = name,
      title = 'Panemux',
      args = { action = 'string' },
      run = function(ctx, args)
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
