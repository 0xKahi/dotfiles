return {
  'NickvanDyke/opencode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  keys = {
    {
      '<leader>oc',
      function()
        require('opencode').ask()
      end,
      desc = '[O]pen [C]ode ask',
      mode = 'n',
    },
    {
      '<leader>oc',
      function()
        require('opencode').ask('@selection: ')
      end,
      desc = '[O]pen [C]ode ask selection',
      mode = 'v',
    },
  },
  opts = {
    auto_fallback_to_enbedded = false,
  },
}
