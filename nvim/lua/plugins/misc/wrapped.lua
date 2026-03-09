return {
  'aikhe/wrapped.nvim',
  dependencies = { 'nvzone/volt' },
  cmd = { 'WrappedNvim' },
  opts = {
    path = vim.fn.stdpath('config'), -- path to your neovim configuration
    border = true,
  },
}
