local converters = require('utils.converters')

local convert_commands = {
  pxOrRem = {
    func = function()
      vim.ui.select({ 'px', 'rem' }, {
        prompt = 'Select px or rem',
      }, function(choice)
        if choice == nil then
          print('No choice made. Conversion cancelled.')
          return
        end

        local value = tonumber(vim.fn.input('Enter the value to convert: '))
        if not value then
          print('Invalid input. Please enter a number.')
          return
        end

        local error, message, title
        if choice == 'px' then
          local converted, err = converters.pxToRem(value)
          error = err
          message = string.format('%dpx is equal to %.3frem', value, converted)
          title = 'PX to REM Convert'
        else
          local converted, err = converters.remToPx(value)
          error = err
          message = string.format('%.3frem is equal to %dpx', value, converted)
          title = 'REM to PX Convert'
        end

        if error then
          vim.notify(error, vim.log.levels.ERROR, { title = title })
          return
        end

        vim.notify(message, vim.log.levels.INFO, {
          title = title,
          timeout = 10000,
        })
      end)
    end,
  },
  msToSec = {
    func = function()
      -- Get the px value from command arguments or prompt the user
      local ms = tonumber(vim.fn.input('Enter Ms: '))

      -- Check if we have a valid number
      if not ms then
        print('Invalid input. Please enter a number.')
        return
      end

      -- Convert px to rem using our imported function
      local sec, error = converters.msToSec(ms)

      if error then
        vim.notify(error, vim.log.levels.ERROR, { title = 'MS to SEC Convert' })
        return
      end

      vim.notify(string.format('%dms is equal to %.2fsec', ms, sec), vim.log.levels.INFO, {
        title = 'MS to SEC Convert',
        timeout = 5000,
      })
    end,
  },
  cryptoBN = {
    func = function()
      -- Get the px value from command arguments or prompt the user
      local bn = tonumber(vim.fn.input('Enter Crypto BigNumber: '))

      -- Check if we have a valid number
      if not bn then
        print('Invalid input. Please enter a number.')
        return
      end

      local amt, error = converters.cryptoBN(bn)

      if error then
        vim.notify(error, vim.log.levels.ERROR, { title = 'CryptoBN convert' })
        return
      end

      -- Print the result
      vim.notify(string.format('converted value is %.2f', amt), vim.log.levels.INFO, {
        title = 'Crypto BN convert',
        timeout = 5000,
      })
    end,
  },
}

vim.api.nvim_create_user_command('Convert', function(opts)
  local cmd = convert_commands[opts.args]
  if cmd then
    cmd.func()
  else
    print('Unknown Convert commands. Available commands: ' .. table.concat(vim.tbl_keys(convert_commands), ', '))
  end
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    return vim.tbl_filter(function(cmd)
      return cmd:match('^' .. ArgLead)
    end, vim.tbl_keys(convert_commands))
  end,
  desc = 'Custom Switch commands. Available: ' .. table.concat(vim.tbl_keys(convert_commands), ', '),
})
