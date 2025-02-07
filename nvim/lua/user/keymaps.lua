-- personal keymap
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true }) -- set space as leader key
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', { noremap = true })
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('n', 'U', '<C-r>', { noremap = true, desc = 'Redo' })

vim.api.nvim_set_keymap('n', ']b', ':bnext<enter>', { desc = '[B]uffer next', noremap = false })
vim.api.nvim_set_keymap('n', '[b', ':bprev<enter>', { desc = '[B]uffer previous', noremap = false })
vim.api.nvim_set_keymap('n', '<leader>bd', ':bdelete<enter>', { desc = '[B]uffer [D]elete', noremap = false })

vim.keymap.set('x', '<leader>p', '"_dP', { desc = '[P]aste to blackhole register', noremap = true, silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { noremap = true, silent = true })
vim.keymap.set(
  { 'n', 'v' },
  '<leader>d',
  '"_d',
  { desc = '[D]elete to blackhole register', noremap = true, silent = true }
)

vim.keymap.set({ 'n', 'v' }, '<leader>sr', function()
  local selected_text
  if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
    -- Visual mode: yank selection to 'v' register
    vim.cmd('normal! "vy')
    selected_text = vim.fn.getreg('v')
  else
    -- Normal mode: get word under cursor
    selected_text = vim.fn.expand('<cword>')
  end
  -- Escape special characters
  local escaped_text = vim.fn.escape(selected_text, '/\\')
  -- Set command line with search pattern, ready for user input
  vim.fn.feedkeys(':%s/' .. escaped_text, 'n')
end, { noremap = true, silent = true, desc = '[S]earch and [R]eplace' })

--- Plugin Remaps --

-- Telescope

-- lualine
-- Map <leader>ll{number} to jump to that buffer
for i = 1, 9 do
  vim.keymap.set(
    'n',
    '<leader>ll' .. i,
    string.format('<cmd>LualineBuffersJump! %d<CR>', i),
    { desc = string.format('[L]ua [L]ine jump to buffer %d', i), silent = false, noremap = true }
  )
end

vim.keymap.set('n', '<leader>llr', function()
  require('lualine').refresh()
  print('Lualine refreshed')
end, { desc = '[L]ua [L]ine [R]efresh', silent = false, noremap = true })

-- Conform (Formatter)
local conform = require('conform')
vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  })
end, { desc = '[F]or[M]at file or range (in visual mode)' })
