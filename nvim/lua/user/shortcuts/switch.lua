local avante_models = {
  ['claude_sonnet'] = 'claude-big',
  ['claude_haiku'] = 'claude-small',
  ['openai_4.1'] = 'openai-big',
  ['openai_4.1-mini'] = 'openai-small',
  ['gemini-flash'] = 'gemini-flash',
  ['gemini-pro'] = 'gemini-pro',
}

local switch_commands = {
  avante = {
    func = function()
      vim.ui.select(vim.tbl_keys(avante_models), {
        prompt = 'Select Avante AI Model',
      }, function(choice)
        if choice == nil then
          print('No choice made. Conversion cancelled.')
          return
        end

        require('avante.api').switch_provider(avante_models[choice])
      end)
    end,
  },
}

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
