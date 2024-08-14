return {
  'mbbill/undotree',
  vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle, { desc = '[U]ndo [T]ree', silent = true, noremap = true }),
}
