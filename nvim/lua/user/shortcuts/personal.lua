-- TODO: gotta redo this part its a mess
local fmt = require('utils.fmt')
vim.api.nvim_create_user_command('LuaFormat', fmt.luaFormat, {})

local converters = require('utils.converters')

vim.api.nvim_create_user_command('PxToRem', function(opts)
  -- Get the px value from command arguments or prompt the user
  local px = tonumber(opts.args)
  if not px then
    px = tonumber(vim.fn.input('Enter px value: '))
  end

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
end, {
  nargs = '?',
  desc = 'Convert px to rem',
})

vim.api.nvim_create_user_command('MsToSec', function(opts)
  -- Get the px value from command arguments or prompt the user
  local ms = tonumber(opts.args)
  if not ms then
    ms = tonumber(vim.fn.input('Enter Ms: '))
  end

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
  print(string.format('%dms is equal to %dsec', ms, sec))
end, {
  nargs = '?',
  desc = 'Convert ms to sec',
})

local inspector = require('utils.inspector')
vim.api.nvim_create_user_command('CheckMapping', function(opts)
  local args = vim.split(opts.args, '%s+')
  if #args ~= 2 then
    print('Usage: CheckMapping <mode> <key>')
    return
  end

  local mode, key = args[1], args[2]
  local result = inspector.getMapping(mode, key)
  print(result)
end, {
  nargs = '+',
  complete = function(ArgLead, CmdLine, CursorPos)
    local modes = { 'n', 'i', 'v', 'x', 's', 'o', '!', 'c', 't' }
    return vim.tbl_filter(function(mode)
      return mode:match('^' .. ArgLead)
    end, modes)
  end,
})
