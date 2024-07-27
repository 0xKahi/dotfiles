-- close quickfix list with q
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.keymap.set('n', 'q', ':cclose<CR>', { buffer = true, noremap = true, silent = true })
  end,
})
