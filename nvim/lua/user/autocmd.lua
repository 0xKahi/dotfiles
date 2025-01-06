------ for closing files ----
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'qf',
  },
  callback = function()
    vim.keymap.set('n', 'q', ':cclose<CR>', { buffer = true, noremap = true, silent = true, desc = '[Q]uit [1]' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'notify',
  },
  callback = function()
    vim.keymap.set('n', 'q', ':q<CR>', { buffer = true, noremap = true, silent = true, desc = '[Q]uit [2]' })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'grug-far',
  },
  callback = function()
    vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, noremap = true, silent = true, desc = '[Q]uit [3]' })
  end,
})
------ for closing files ------

------ for markdown ------
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.conceallevel = 1
  end,
})
------ for markdown ------

------ for RESTY PLUGIN ------
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'rest_nvim_result',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'json' },
  callback = function()
    vim.api.nvim_set_option_value('formatprg', 'jq', { scope = 'local' })
  end,
})
------ for RESTY PLUGIN ------
