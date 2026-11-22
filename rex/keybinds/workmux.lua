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
  local command = { 'bash', '-c', hold_on_error, 'workmux', 'workmux' }
  for _, arg in ipairs(args) do
    command[#command + 1] = arg
  end

  JoJo.float.create({
    command = command,
    block_id = ctx.block_id,
    bounds = JoJo.float.layout.log,
  })
end

--- Run a command on the server from the focused block's directory, with your shell's PATH.
--- On failure, shows the error in a log float and returns nil.
---@param ctx table action context
---@param argv string[] program and its arguments
---@return string? stdout
local function exec(ctx, argv)
  local cwd = JoJo.utils.get_cwd(ctx.block_id)
  local result, err = rex.exec(argv, {
    cwd = cwd,
    -- REX_SESSION etc. let workmux see this Rex session, e.g. for agent statuses
    env = {
      PATH = JoJo.utils.get_shell_path(),
      REX_SESSION = ctx.session_id,
      REX_BLOCK = ctx.block_id,
      TERM_PROGRAM = 'rex',
    },
  })
  if result and result.ok then
    return result.stdout
  end

  local message = result and JoJo.utils.split_lines(result.stderr) or { tostring(err) }
  message[#message + 1] = ''
  message[#message + 1] = 'cwd: ' .. tostring(cwd)
  JoJo.float.create_log('error', {
    title = table.concat(argv, ' ') .. ' failed',
    message = message,
    block_id = ctx.block_id,
  })
end

---@param ctx table action context
---@param args string[] workmux-fzf.sh arguments, e.g. { 'open' }
local function run_workmux_fzf(ctx, args)
  local workmux_fzf = os.getenv('HOME') .. '/.config/tmux/scripts/workmux-fzf.sh'
  local command = { workmux_fzf }

  for _, arg in ipairs(args) do
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
          local stdout = exec(ctx, { 'git', 'branch', '--format=%(refname:short)' })
          if not stdout then
            return
          end

          local items = {}
          for _, name in ipairs(JoJo.utils.split_lines(stdout)) do
            items[#items + 1] = { id = name, icon = 'branch' }
          end
          if #items == 0 then
            return
          end

          local branch = rex.ui.pick({
            title = 'add worktree from branch',
            placeholder = 'branch',
            confirm = 'workmux add',
            items = items,
          })
          if not branch then
            return
          end

          run_workmux(ctx, { 'add', branch })
          return
        end

        local fzf_actions = {
          open = { 'open' },
          remove = { 'remove', '-k', '--filter', 'is_main=false', '--multi' },
          close = { 'close', '--filter', 'is_main=false,is_open=true' },
        }
        if fzf_actions[args.action] then
          run_workmux_fzf(ctx, fzf_actions[args.action])
          return
        end
      end,
    })

    for key, action in JoJo.utils.rpairs(workmux_keys) do
      rex.bind(mode_key(key), 'workmux', { action = action })
    end
  end,
})
