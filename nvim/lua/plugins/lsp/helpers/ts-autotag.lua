return {
  {
    'windwp/nvim-ts-autotag',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'html', 'javascriptreact', 'typescriptreact' },
    -- event = { 'BufEnter' },
    config = function()
      require('nvim-ts-autotag').setup({})
    end,
  },
}
