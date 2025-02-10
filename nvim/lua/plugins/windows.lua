return {
  {
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
  },
  {
    'anuvyklack/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
      'anuvyklack/animation.nvim',
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false

      require('windows').setup({
        autowidth = {
          enable = true,
          winwidth = 5,
          filetype = {
            help = 3,
          },
        },
        ignore = {
          buftype = { 'quickfix', 'oil', 'telescope', 'DiffviewFilePanel' },
          filetype = { 'NvimTree', 'neo-tree', 'undotree', 'gundo', 'oil', 'trouble', 'telescope', 'DiffviewFiles' },
        },
        animation = {
          -- enable = true,
          -- duration = 300,
          -- fps = 30,
          -- easing = 'in_out_sine',
        },
      })

      vim.keymap.set('n', '<C-w>z', ':WindowsMaximize<CR>', { desc = '(W)indows [Z]oom' })
      vim.keymap.set('n', '<C-w>_', ':WindowsMaximizeVertically<CR>', { desc = '(W)indows maximize vertical' })
      vim.keymap.set('n', '<C-w>|', ':WindowsMaximizeHorizontally <CR>', { desc = '(W)indows maximize horizontal' })
      vim.keymap.set('n', '<C-w>=', ':WindowsEqualize<CR>', { desc = '(W)indows maximize equalize' })
    end,
  },
}
