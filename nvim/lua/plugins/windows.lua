return {
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left, { desc = 'navigate left pane' })
      vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down, { desc = 'navigate down pane' })
      vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up, { desc = 'navigate up pane' })
      vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right, { desc = 'navigate right pane' })
      -- vim.keymap.set("n", "<C-c>", "<C-w>c")

      vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
      vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
      vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
      vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
    end,
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
