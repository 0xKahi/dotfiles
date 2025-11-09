----------------------------------------
---------------- core ------------------
----------------------------------------

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
  local cursorWord = require('utils.misc').get_word_under_cursor()
  -- require('utils.misc').copy_to_clipboard(cursorWord.selectedText)
  -- Escape special characters and
  -- Set command line with search pattern, ready for user input
  local escaped_text = vim.fn.escape(cursorWord.selectedText, '/\\')
  vim.fn.feedkeys(':%s/' .. escaped_text, 'n')
end, { noremap = true, silent = true, desc = '[S]earch and [R]eplace' })

vim.keymap.set({ 'n', 'v' }, '<leader>sR', function()
  local cursorWord = require('utils.misc').get_word_under_cursor()
  require('utils.misc').copy_to_clipboard(cursorWord.selectedText)
  -- Escape special characters and
  -- Set command line with search pattern, ready for user input
  local escaped_text = vim.fn.escape(cursorWord.selectedText, '/\\')
  vim.fn.feedkeys(':%s/\\<' .. escaped_text .. '\\>', 'n')
end, { noremap = true, silent = true, desc = '[S]earch and [R]eplace Exact word' })

-- keymap to format string under cursor
vim.keymap.set({ 'n', 'v' }, '<leader>fs', function()
  local formatList = {
    ['camelCase'] = require('utils.fmt').toCamelCase,
    ['PascalCase'] = require('utils.fmt').toPascalCase,
    ['snake_case'] = require('utils.fmt').toSnakeCase,
    ['kebab-case'] = require('utils.fmt').toKebabCase,
    ['UPPER-CASE'] = require('utils.fmt').toUpperCase,
  }

  local cursorWord = require('utils.misc').get_word_under_cursor()

  vim.ui.select(vim.tbl_keys(formatList), {
    prompt = 'Choose Format Type',
  }, function(formatChoice)
    if formatChoice == nil then
      print('No choice made.')
      return
    end

    -- Replace the selected text or word under cursor with the snake_case version
    if cursorWord.cursorPos then
      vim.fn.setpos("'<", cursorWord.cursorPos.startPos)
      vim.fn.setpos("'>", cursorWord.cursorPos.endPos)
      vim.cmd('normal! gvc' .. formatList[formatChoice](cursorWord.selectedText))
    else
      vim.cmd('normal! ciw' .. formatList[formatChoice](cursorWord.selectedText))
    end
  end)
end, { noremap = true, silent = true, desc = '[F]ormat [S]tring' })

----------------------------------------
------------- diagnostic ---------------
----------------------------------------

-- toggle nvim virtual lines
vim.keymap.set('n', 'gk', function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_config })
end, { desc = 'Toggle diagnostic virtual_lines' })

vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

----------------------------------------
--------------- format -----------------
----------------------------------------

vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
  require('utils.lsp-fmt').lsp_format(0)
end, { desc = '[F]or[M]at file' })

----------------------------------------
-------------- personal ----------------
----------------------------------------

vim.keymap.set('n', '<leader>cb', function()
  local selectors = require('config.selectors')
  selectors.git_ref(function(ref)
    Global:set('git_base', ref)
    vim.cmd('Gitsigns change_base ' .. ref)
  end)
end, { desc = '[C]hange [B]ase', silent = true, noremap = true })

-- vim.keymap.set('n', '<leader>pg', function()
--   print(Global:get('git_base'))
-- end, { desc = '[P]rint [G]lobal', silent = true, noremap = true })
