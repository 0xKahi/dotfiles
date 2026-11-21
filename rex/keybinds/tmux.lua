-- tmux keybinds (migrated from ~/.config/tmux), prefix ^b
local prefix = JoJo.key.prefix

-- Pass ^b through to programs that use it themselves (^b now starts sequences)
rex.bind(prefix('ctrl+b'), 'pane.send_key', { key = 'ctrl+b' })

rex.bind(prefix('shift+r'), 'client.config.reload')
rex.bind(prefix('c'), 'client.tab.new')

-- Pick tab by number (tmux `select-window -t N`, base-index 1); ^b 0 jumps to the last tab
for i = 1, 9 do
  rex.bind(prefix(tostring(i)), 'client.tab.goto', { index = i })
end

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
rex.bind(prefix('z'), 'pane.zoom')

rex.bind(prefix('h'), 'pane.focus', { direction = 'left' })
rex.bind(prefix('j'), 'pane.focus', { direction = 'down' })
rex.bind(prefix('k'), 'pane.focus', { direction = 'up' })
rex.bind(prefix('l'), 'pane.focus', { direction = 'right' })

rex.bind(prefix('q'), 'pane.close')

rex.bind(prefix('['), 'pane.copy_mode.enter')

-- Repeatable resize (tmux `bind -r , . = -`): prefix+key resizes once and enters
-- the `resize` mode, where the bare keys keep resizing. Escape/q leaves the mode.
-- Rex has no repeat-time, so the mode stays until you leave it.
JoJo.key.create_mode('resize', {
  exclusive = true, -- swallow stray keys instead of typing them
  exit = { 'q' },
  setup = function(mode_key, name)
    local resize_keys = {
      [','] = 'left',
      ['.'] = 'right',
      ['='] = 'up',
      ['-'] = 'down',
    }

    rex.action({
      name = 'resize_repeat',
      title = 'Resize Pane (Repeatable)',
      args = { direction = 'string' },
      run = function(_, args)
        rex.client.queue('pane.resize', { direction = args.direction })
        rex.client.queue('client.mode.enter', { name = name })
      end,
    })

    for key, direction in pairs(resize_keys) do
      rex.bind(prefix(key), 'resize_repeat', { direction = direction })
      rex.bind(mode_key(key), 'pane.resize', { direction = direction })
    end
  end,
})
