local function clear_buffers()
  local buffers = vim.api.nvim_list_bufs() -- list all buffers
  local current_buf = vim.api.nvim_get_current_buf() -- current buffer

  local cleared_count = 0
  local skipped_count = 0
  for _, buf in ipairs(buffers) do
    -- Skip the current buffer
    if buf ~= current_buf then
      -- Check if the buffer is loaded and modifiable
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modifiable then
        -- Check if the buffer has unsaved changes
        if vim.bo[buf].modified then
          skipped_count = skipped_count + 1
        else
          -- Delete the buffer
          vim.api.nvim_buf_delete(buf, { force = true })
          cleared_count = cleared_count + 1
        end
      end
    end
  end
  print('Cleared ' .. cleared_count .. ' buffer(s). Skipped ' .. skipped_count .. ' unsaved buffer(s).')
end

vim.api.nvim_create_user_command('ClearBuffers', clear_buffers, {})
