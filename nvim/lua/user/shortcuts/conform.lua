local function show_notification(message, level)
  require('snacks.notifier.notify')(message, level, { title = 'conform.nvim' })
end

vim.api.nvim_create_user_command('FormatToggle', function(args)
  local is_global = args.bang
  if is_global then
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    if vim.g.disable_autoformat then
      show_notification('format-on-save disabled globally', 'info')
    else
      show_notification('format-on-save enabled globally', 'info')
    end
  else
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    if vim.b.disable_autoformat then
      show_notification('format-on-save disabled for this buffer', 'info')
    else
      show_notification('format-on-save enabled for this buffer', 'info')
    end
  end
end, {
  desc = 'Toggle autoformat-on-save',
  bang = true,
})
