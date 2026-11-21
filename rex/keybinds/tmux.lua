local prefix = JoJo.key.prefix

-- Pass ^b through to programs that use it themselves (^b now starts sequences)
rex.bind(prefix('ctrl+b'), 'pane.send_key', { key = 'ctrl+b' })

rex.bind(prefix('shift+r'), 'client.config.reload')
rex.bind(prefix('c'), function()
  rex.session.new_window({
    layout = rex.layout.block({
      flavor = 'com.superlogical.terminal.shell',
      options = { cwd = os.getenv('HOME') },
    }),
  })
  return true
end)
rex.bind(prefix('c'), 'client.tab.new')
rex.bind(prefix('r'), 'client.tab.rename')
rex.bind(prefix('ctrl+r'), 'session.rename')

-- Pick tab by number (tmux `select-window -t N`, base-index 1); ^b 0 jumps to the last tab
for i = 1, 9 do
  rex.bind(prefix(tostring(i)), 'client.tab.goto', { index = i })
end

rex.bind(prefix('v'), 'pane.split', { direction = 'right' })
rex.bind(prefix('s'), function(ctx)
  rex.session.new_split({
    anchor_id = ctx.block_id,
    direction = 'vertical',
    side = 'after',
    ratio = 0.8,
    focus = true,
    layout = rex.layout.block({
      flavor = 'com.superlogical.terminal.shell',
      options = { cwd = JoJo.utils.get_cwd(ctx.block_id) },
    }),
  })
  return true
end)
rex.bind(prefix('z'), 'pane.zoom')

rex.bind(prefix('h'), 'pane.focus', { direction = 'left' })
rex.bind(prefix('j'), 'pane.focus', { direction = 'down' })
rex.bind(prefix('k'), 'pane.focus', { direction = 'up' })
rex.bind(prefix('l'), 'pane.focus', { direction = 'right' })

rex.bind(prefix('q'), 'pane.close')

rex.bind(prefix('['), 'pane.copy_mode.enter')
