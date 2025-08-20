local switch_commands = {}

vim.api.nvim_create_user_command('Switch', function(opts)
  local cmd = switch_commands[opts.args]
  if cmd then
    cmd.func()
  else
    print('Unknown Switch commands. Available commands: ' .. table.concat(vim.tbl_keys(switch_commands), ', '))
  end
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    return vim.tbl_filter(function(cmd)
      return cmd:match('^' .. ArgLead)
    end, vim.tbl_keys(switch_commands))
  end,
  desc = 'Custom Switch commands. Available: ' .. table.concat(vim.tbl_keys(switch_commands), ', '),
})
