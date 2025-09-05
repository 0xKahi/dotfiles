return {
  -- dir = '~/Desktop/code/editor_extras/vim_plugins/lazy-splits.nvim',
  '0xKahi/lazy-splits.nvim',
  enabled = true,
  keys = {
    {
      '<C-h>',
      function()
        require('lazy-splits').move.left()
      end,
      { desc = 'navigate left pane', mode = { 'n' } },
    },
    {
      '<C-j>',
      function()
        require('lazy-splits').move.down()
      end,
      { desc = 'navigate down pane', mode = { 'n' } },
    },
    {
      '<C-k>',
      function()
        require('lazy-splits').move.up()
      end,
      { desc = 'navigate up pane', mode = { 'n' } },
    },
    {
      '<C-l>',
      function()
        require('lazy-splits').move.right()
      end,
      { desc = 'navigate right pane', mode = { 'n' } },
    },
    {
      '<A-h>',
      function()
        require('lazy-splits').resize.left()
      end,
      { desc = 'resize left', mode = { 'n' } },
    },
    {
      '<A-j>',
      function()
        require('lazy-splits').resize.down()
      end,
      { desc = 'resize down', mode = { 'n' } },
    },
    {
      '<A-k>',
      function()
        require('lazy-splits').resize.up()
      end,
      { desc = 'resize up', mode = { 'n' } },
    },
    {
      '<A-l>',
      function()
        require('lazy-splits').resize.right()
      end,
      { desc = 'resize right', mode = { 'n' } },
    },
  },
  opts = {
    resize = {
      ignored_events = {
        'BufEnter',
        'WinEnter',
      },
      ignored_filetypes = { 'NvimTree' },
      default_amount = 3,
    },
    move = {
      wrap_at_edge = true,
    },
  },
}
