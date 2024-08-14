return {
  'kdheepak/lazygit.nvim',
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = '[L]azy [G]it' },
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}
