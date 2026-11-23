local prefix = JoJo.key.prefix

-- Pass ^b through to programs that use it themselves (^b now starts sequences)
rex.bind(prefix('ctrl+b'), 'pane.send_key', { key = 'ctrl+b' })

rex.bind(prefix('shift+r'), 'client.config.reload')
-- fix so that we open new tab in `~` instead of cwd
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
      options = { cwd = JoJo.rex.get_cwd(ctx.block_id) },
    }),
  })
  return true
end)
rex.bind(prefix('z'), 'pane.zoom')

rex.bind(prefix('h'), 'pane.focus', { direction = 'left' })
rex.bind(prefix('j'), 'pane.focus', { direction = 'down' })
rex.bind(prefix('k'), 'pane.focus', { direction = 'up' })
rex.bind(prefix('l'), 'pane.focus', { direction = 'right' })

rex.bind(prefix('['), 'pane.copy_mode.enter')

-- Close the pane; if it's the window's last pane close the window, if that's the session's last window
-- destroy the session (tmux kill-pane cascade)
rex.bind(prefix('q'), function(ctx)
  local view = rex.session.view({})
  local session_id = view.session_id

  for _, window in ipairs(view.windows or {}) do
    local block_count, has_block = 0, false
    for _, layer in ipairs(window.layers or {}) do
      for _, block in ipairs(layer.blocks or {}) do
        block_count = block_count + 1
        has_block = has_block or block.block_id == ctx.block_id
      end
    end

    if has_block then
      if block_count > 1 then
        rex.call('block.close', { session_id = session_id, block_id = ctx.block_id })
      elseif #view.windows > 1 then
        rex.session.close_window({ window_id = window.window_id })
      else
        rex.call('session.destroy', { session_id = session_id })
      end
      return true
    end
  end

  return false
end)

rex.bind(prefix('i'), 'client.tab_style.toggle')
