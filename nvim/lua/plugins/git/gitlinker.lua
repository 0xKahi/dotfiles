return {
  'linrongbin16/gitlinker.nvim',
  cmd = 'GitLink',
  opts = {},
  keys = {
    { '<leader>gl', '<cmd>GitLink<cr>', mode = { 'n', 'v' }, desc = '[G]it [L]ink' },
    { '<leader>gL', '<cmd>GitLink!<cr>', mode = { 'n', 'v' }, desc = 'Open [G]it [L]ink' },
  },
}
