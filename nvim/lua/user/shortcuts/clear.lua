local function clear_buffers()
  local buffers = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()

  -- Get pinned buffer paths and convert to a lookup table of buffer numbers
  local pinned_bufs = {}
  local pinned_str = vim.g['BufferlinePinnedBuffers']
  if pinned_str and pinned_str ~= '' then
    for _, path in ipairs(vim.split(pinned_str, ',')) do
      local buf_id = vim.fn.bufnr(path)
      if buf_id ~= -1 then
        pinned_bufs[buf_id] = true
      end
    end
  end

  local cleared_count = 0
  local skipped_count = 0
  local pinned_count = 0

  for _, buf in ipairs(buffers) do
    -- Skip current buffer and pinned buffers
    if buf ~= current_buf then
      if pinned_bufs[buf] then
        pinned_count = pinned_count + 1
      elseif vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modifiable then
        if vim.bo[buf].modified then
          skipped_count = skipped_count + 1
        else
          vim.api.nvim_buf_delete(buf, { force = true })
          cleared_count = cleared_count + 1
        end
      end
    end
  end

  print(
    string.format(
      'Cleared %d buffer(s). Skipped %d unsaved buffer(s). Preserved %d pinned buffer(s).',
      cleared_count,
      skipped_count,
      pinned_count
    )
  )
end

local clear_commands = {
  buffers = { func = clear_buffers, desc = 'clear all buffers' },
  qf_list = {
    func = function()
      vim.api.nvim_command('call setqflist([])')
    end,
    desc = 'clear quickfix list',
  },
  avante = {
    func = function()
      vim.api.nvim_command('AvanteClear')
    end,
    desc = 'clear Avante buffers',
  },
}

-- Create custom command for clearing stuff
vim.api.nvim_create_user_command('Clear', function(opts)
  local cmd = clear_commands[opts.args]
  if cmd then
    cmd.func()
  else
    print('Unknown clear command. Available commands: ' .. table.concat(vim.tbl_keys(clear_commands), ', '))
  end
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    return vim.tbl_filter(function(cmd)
      return cmd:match('^' .. ArgLead)
    end, vim.tbl_keys(clear_commands))
  end,
  desc = 'Custom clear commands. Available: ' .. table.concat(vim.tbl_keys(clear_commands), ', '),
})
