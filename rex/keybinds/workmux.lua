-- runs "$@"; on failure keeps the pane open with the exit status until q is pressed
local hold_on_error = [=[
"$@" && exit 0
status=$?
printf '\n\033[1;31m%s exited with %s\033[0m\n\033[2mpress q to close\033[0m' "$*" "$status"
while IFS= read -rsn1 key; do [[ $key == q ]] && break; done
]=]

--- Run `workmux <args...>` in a small floating pane that closes on success and stays open on failure.
---@param ctx table action context
---@param args string[] workmux arguments, e.g. { 'add', 'feature/foo' }
local function run_workmux(ctx, args)
  -- Rex no longer sets REX_SESSION in terminals (only REX_BLOCK), but workmux still requires it
  local command = { 'env', 'REX_SESSION=' .. ctx.session_id, 'bash', '-c', hold_on_error, 'workmux', 'workmux' }
  for _, arg in ipairs(args) do
    command[#command + 1] = arg
  end

  JoJo.float.create({
    command = command,
    block_id = ctx.block_id,
    bounds = JoJo.float.layout.log,
    interactive = true,
  })
end

--- Toggle the workmux sidebar in a hidden block on the session's host. `rex.exec` would always run it on the
--- home Mac, which breaks for a remote session (`ctx.server` set).
---@param ctx table action context
local function toggle_sidebar(ctx)
  -- REX_SESSION/REX_BLOCK point workmux at the focused pane, not the hidden block it runs in
  JoJo.rex.run_hidden(ctx, {
    'env',
    'REX_SESSION=' .. ctx.session_id,
    'REX_BLOCK=' .. ctx.block_id,
    'workmux',
    'sidebar',
  }, { label = 'hidden-workmux-sidebar' })
end

--- Run a ~/.config/tmux/scripts fzf script in a popup float, on whichever host the session is on.
---@param ctx table action context
---@param script string script file name, e.g. 'workmux-fzf.sh'
---@param args? string[] script arguments, e.g. { 'open' }
local function run_fzf_script(ctx, script, args)
  local command = { 'env', 'REX_SESSION=' .. ctx.session_id, os.getenv('HOME') .. '/.config/tmux/scripts/' .. script }

  for _, arg in ipairs(args or {}) do
    command[#command + 1] = arg
  end

  JoJo.float.create({
    command = command,
    block_id = ctx.block_id,
    bounds = JoJo.float.layout.popup,
    interactive = true,
  })
end

JoJo.key.create_mode('workmux', {
  exclusive = true,
  once = true,
  enter = { JoJo.key.prefix('w') },
  exit = { 'q' },
  setup = function(mode_key)
    local workmux_keys = {
      s = 'sidebar',
      d = 'dashboard',
      a = 'add',
      b = 'add_branch',
      o = 'open',
      r = 'remove',
      c = 'close',
    }

    rex.action({
      name = 'workmux',
      title = 'Workmux',
      args = { action = 'string' },
      run = function(ctx, args)
        if args.action == workmux_keys.s then
          toggle_sidebar(ctx)
          return
        end

        if args.action == workmux_keys.d then
          JoJo.float.create({
            command = { 'workmux', 'dashboard' },
            block_id = ctx.block_id,
          })
          return
        end

        if args.action == workmux_keys.a then
          local branch = rex.ui.input({
            title = 'new branch',
            placeholder = 'feat/…',
            confirm = 'workmux add',
          })
          branch = branch and JoJo.utils.trim(branch)
          if not branch or branch == '' then
            return
          end

          run_workmux(ctx, { 'add', branch })
          return
        end

        if args.action == workmux_keys.b then
          run_fzf_script(ctx, 'workmux-add-from-branch.sh')
          return
        end

        local fzf_actions = {
          open = { 'open' },
          remove = { 'remove', '-k', '--filter', 'is_main=false', '--multi' },
          close = { 'close', '--filter', 'is_main=false,is_open=true' },
        }
        if fzf_actions[args.action] then
          run_fzf_script(ctx, 'workmux-fzf.sh', fzf_actions[args.action])
          return
        end
      end,
    })

    for key, action in JoJo.utils.rpairs(workmux_keys) do
      rex.bind(mode_key(key), 'workmux', { action = action })
    end
  end,
})
