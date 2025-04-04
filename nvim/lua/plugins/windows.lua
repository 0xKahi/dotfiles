return {
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
          filetype = {
            'NvimTree',
            'neo-tree',
            'undotree',
            'gundo',
            'oil',
            'trouble',
            'telescope',
            'DiffviewFiles',
            'Avante',
            'AvanteSelectedFiles',
            'AvanteInput',
          },
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
