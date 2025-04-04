return {
  'mrjones2014/smart-splits.nvim',
  keys = {
    {
      '<C-h>',
      function()
        require('smart-splits').move_cursor_left()
      end,
      { desc = 'navigate left pane', mode = { 'n' } },
    },
    {
      '<C-j>',
      function()
        require('smart-splits').move_cursor_down()
      end,
      { desc = 'navigate down pane', mode = { 'n' } },
    },
    {
      '<C-k>',
      function()
        require('smart-splits').move_cursor_up()
      end,
      { desc = 'navigate up pane', mode = { 'n' } },
    },
    {
      '<C-l>',
      function()
        require('smart-splits').move_cursor_right()
      end,
      { desc = 'navigate right pane', mode = { 'n' } },
    },
    {
      '<A-h>',
      function()
        require('smart-splits').resize_left()
      end,
      { desc = 'resize left', mode = { 'n' } },
    },
    {
      '<A-j>',
      function()
        require('smart-splits').resize_down()
      end,
      { desc = 'resize down', mode = { 'n' } },
    },
    {
      '<A-k>',
      function()
        require('smart-splits').resize_up()
      end,
      { desc = 'resize up', mode = { 'n' } },
    },
    {
      '<A-l>',
      function()
        require('smart-splits').resize_right()
      end,
      { desc = 'resize right', mode = { 'n' } },
    },
  },
}
