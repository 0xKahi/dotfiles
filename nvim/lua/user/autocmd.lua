-- close quickfix list with q
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.keymap.set(
      'n',
      'q',
      ':cclose<CR>',
      { buffer = true, noremap = true, silent = true, desc = '[Q]uickfix [Q]uit' }
    )
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'notify',
  callback = function()
    vim.keymap.set('n', 'q', ':q<CR>', { buffer = true, noremap = true, silent = true, desc = '[Q]uit notify' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.conceallevel = 1
  end,
})
