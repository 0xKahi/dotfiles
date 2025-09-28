local options_keys = {
  '  ERROR',
  '  WARN',
  '  INFO',
  '  HINT',
}
local options = {
  [options_keys[1]] = vim.diagnostic.severity.ERROR,
  [options_keys[2]] = vim.diagnostic.severity.WARN,
  [options_keys[3]] = vim.diagnostic.severity.INFO,
  [options_keys[4]] = vim.diagnostic.severity.HINT,
}

local commands = {
  specific = {
    func = function()
      vim.ui.select(options_keys, {
        prompt = 'diagnostic severity to filter',
      }, function(choice)
        if choice == nil then
          print('No choice made.')
          return
        end
        local severity = options[choice]

        -- Get current diagnostic config
        local current_config = vim.diagnostic.config()
        current_config.signs.severity = severity
        current_config.jump.severity = severity
        current_config.virtual_text.severity = severity

        -- Apply the updated config
        vim.diagnostic.config(current_config)

        print('Diagnostic filter applied: ' .. choice)
      end)
    end,
  },
  min = {
    func = function()
      vim.ui.select(options_keys, {
        prompt = 'minimum diagnostic severity',
      }, function(choice)
        if choice == nil then
          print('No choice made.')
          return
        end
        local severity = options[choice]

        -- Get current diagnostic config
        local current_config = vim.diagnostic.config()
        current_config.signs.severity = { min = severity }
        current_config.jump.severity = { min = severity }
        current_config.virtual_text.severity = { min = severity }

        -- Apply the updated config
        vim.diagnostic.config(current_config)

        print('Diagnostic min filter applied: ' .. choice)
      end)
    end,
  },
  reset = {
    func = function()
      local current_config = vim.diagnostic.config()
      current_config.signs = require('utils.misc').filter_out(current_config.signs, 'severity')
      current_config.jump = require('utils.misc').filter_out(current_config.jump, 'severity')
      current_config.virtual_text = require('utils.misc').filter_out(current_config.virtual_text, 'severity')

      vim.diagnostic.config(current_config)
      print('Diagnostic filter reset to default.')
    end,
  },
}

vim.api.nvim_create_user_command('FilterDiagnostic', function(opts)
  local cmd = commands[opts.args]
  if cmd then
    cmd.func()
  else
    print('Unknown FilterDiagnostic commands. Available commands: ' .. table.concat(vim.tbl_keys(commands), ', '))
  end
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    return vim.tbl_filter(function(cmd)
      return cmd:match('^' .. ArgLead)
    end, vim.tbl_keys(commands))
  end,
  desc = 'Custom FilterDiagnostic commands. Available: ' .. table.concat(vim.tbl_keys(commands), ', '),
})
