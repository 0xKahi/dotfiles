-- prefix + @
rex.bind(JoJo.key.prefix('shift+2'), 'pane.float')

JoJo.key.create_mode('panemux', {
  exclusive = true,
  once = true,
  enter = { JoJo.key.prefix('a') },
  exit = { 'q' },
  setup = function(mode_key, name)
    local panemux_keys = {
      n = 'new float',
      r = 'rename pane',
    }

    rex.action({
      name = name,
      title = 'Panemux',
      args = { action = 'string' },
      run = function(ctx, args)
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
