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
      rex.bind(JoJo.key.prefix(key), 'resize_repeat', { direction = direction })
      rex.bind(mode_key(key), 'pane.resize', { direction = direction })
    end
  end,
})
