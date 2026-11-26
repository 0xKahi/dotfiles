-- Move mode (prefix g):
--   h/j/k/l: swap tiled panes or nudge floating panes (stays in mode)
--   H/J/K/L/C: snap a floating pane to an edge or center, then exit mode (no-op + exit on tiled panes)
JoJo.key.create_mode('move_mode', {
  exclusive = true,
  enter = { JoJo.key.prefix('g') },
  exit = { 'q' },
  setup = function(mode_key, name)
    local move_keys = {
      h = 'left',
      j = 'down',
      k = 'up',
      l = 'right',
    }

    for key, direction in pairs(move_keys) do
      rex.bind(mode_key(key), 'pane.move', { direction = direction })
    end

    local snap_keys = {
      ['shift+h'] = 'left',
      ['shift+j'] = 'bottom',
      ['shift+k'] = 'top',
      ['shift+l'] = 'right',
      ['c'] = 'center',
    }

    local snap_action = name .. '_snap'
    rex.action({
      name = snap_action,
      title = 'Snap Floating Pane',
      args = { target = 'string' },
      run = function(ctx, args)
        local layer = ctx.block_id and JoJo.float.find_layer(ctx.block_id)
        if layer then
          rex.session.resize_layer({
            layer_id = layer.layer_id,
            bounds = JoJo.float.snap_bounds(layer.bounds, args.target, { block_id = ctx.block_id }),
          })
        end
        rex.client.queue('client.mode.exit')
      end,
    })

    for key, target in JoJo.utils.rpairs(snap_keys) do
      rex.bind(mode_key(key), snap_action, { target = target })
    end
  end,
})
