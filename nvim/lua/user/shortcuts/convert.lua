local converters = require('utils.converters')

local convert_commands = {
  pxToRem = {
    func = function()
      local px = tonumber(vim.fn.input('Enter px value: '))

      -- Check if we have a valid number
      if not px then
        print('Invalid input. Please enter a number.')
        return
      end

      -- Convert px to rem using our imported function
      local rem, error = converters.pxToRem(px)

      if error then
        print(error)
        return
      end

      -- Print the result
      print(string.format('%dpx is equal to %.2frem', px, rem))
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
        print(error)
        return
      end

      -- Print the result
      print(string.format('%dms is equal to %.2fsec', ms, sec))
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
        print(error)
        return
      end

      -- Print the result
      print(string.format('converted value is %.2f', amt))
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
