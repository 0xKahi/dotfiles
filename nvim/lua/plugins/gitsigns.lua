return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    config = function()
      require('gitsigns').setup()

      vim.keymap.set(
        'n',
        '<leader>ob',
        ':Gitsigns blame<cr>',
        { desc = '[O]pen git [B]lame', silent = true, noremap = true }
      )
    end,
  },
}
