-- tmux keybinds (migrated from ~/.config/tmux), prefix ^b
local prefix = JoJo.key.prefix

-- Pass ^b through to programs that use it themselves (^b now starts sequences)
rex.bind(prefix('ctrl+b'), 'pane.send_key', { key = 'ctrl+b' })

rex.bind(prefix('shift+r'), 'client.config.reload')
rex.bind(prefix('z'), 'pane.zoom')

rex.bind(prefix('s'), function(ctx)
  rex.session.new_split({
    anchor_id = ctx.block_id,
    direction = 'vertical',
    side = 'after',
    ratio = 0.8, -- share for the top pane, new bottom pane gets 20%
    focus = true,
    layout = rex.layout.block({ flavor = 'com.superlogical.terminal.shell' }),
  })
  return true
end)
rex.bind(prefix('v'), 'pane.split', { direction = 'right' })

rex.bind(prefix('h'), 'pane.focus', { direction = 'left' })
rex.bind(prefix('j'), 'pane.focus', { direction = 'down' })
rex.bind(prefix('k'), 'pane.focus', { direction = 'up' })
rex.bind(prefix('l'), 'pane.focus', { direction = 'right' })

rex.bind(prefix('q'), 'pane.close')
