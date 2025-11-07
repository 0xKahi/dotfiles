vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ timeout = 200, visual = true, higroup = 'HighlightYank' })
  end,
})
