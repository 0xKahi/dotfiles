vim.cmd('packadd nvim.undotree')
-- vim.keymap.set("n", "<leader>u", require("undotree").open)
vim.keymap.set('n', '<leader>ut', require('undotree').open, { desc = '[U]ndo [T]ree', silent = true, noremap = true })
-- vim.keymap.set('n', '<leader>ut', function()
--   require('undotree').open({
--     command = math.floor(vim.api.nvim_win_get_width(0) / 4) .. 'vnew',
--   })
-- end, { desc = '[U]ndo [T]ree', silent = true, noremap = true })

vim.cmd('packadd nvim.difftool')
-- require('vim._core.ui2').enable()
