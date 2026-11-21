JoJo.key.create_mode('workmux', {
  exclusive = true,
  once = true,
  enter = { JoJo.key.prefix('w') },
  exit = { 'q' },
  setup = function(mode_key)
    local workmux_keys = {
      s = 'sidebar',
      d = 'dashboard',
    }

    rex.action({
      name = 'workmux',
      title = 'Workmux',
      args = { action = 'string' },
      run = function(ctx, args)
        if args.action == workmux_keys.s then
          local result, err = rex.exec({ 'workmux', 'sidebar' }, {
            env = {
              PATH = JoJo.utils.get_shell_path(),
              REX_SESSION = ctx.session_id,
              REX_BLOCK = ctx.block_id,
              TERM_PROGRAM = 'rex',
            },
          })
          if not result then
            rex.log('error', 'workmux sidebar failed to start: ' .. tostring(err))
          elseif not result.ok then
            rex.log('error', 'workmux sidebar exited ' .. result.code .. ': ' .. result.stderr)
          end
          return
        end

        if args.action == workmux_keys.d then
          JoJo.float.create({
            command = { 'workmux', 'dashboard' },
            block_id = ctx.block_id,
          })
          return
        end
      end,
    })

    for key, action in pairs(workmux_keys) do
      rex.bind(mode_key(key), 'workmux', { action = action })
    end
  end,
})
