------ for closing files ----
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'notify',
    'help',
    'qf',
    'gitsigns-blame',
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

------ for markdown ------
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.conceallevel = 2
  end,
})

------ for config files ------
vim.api.nvim_create_autocmd('BufRead', {
  group = vim.api.nvim_create_augroup('ConfigFiles', { clear = true }),
  pattern = { 'config' },
  callback = function()
    vim.bo.filetype = 'dosini'
  end,
})

vim.api.nvim_create_autocmd('BufRead', {
  group = vim.api.nvim_create_augroup('EnvFiles', { clear = true }),
  pattern = { '.env', '.env.*' },
  callback = function()
    vim.bo.filetype = 'sh'
  end,
})

--------- no auto continue cmments --------
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    -- disable insert comment header on new line
    vim.opt.formatoptions:remove({ 'c', 'r', 'o' })
  end,
})
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
