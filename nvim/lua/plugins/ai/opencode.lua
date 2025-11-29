return {
  'NickvanDyke/opencode.nvim',
  -- commit = '08bf7763fe1f363a70c6a84f6bbb82fe111da8b5', -- commit hash before v1.0.0 release
  dependencies = { 'folke/snacks.nvim' },
  keys = {
    {
      '<leader>oc',
      function()
        require('opencode').ask('', { submit = false })
      end,
      desc = '[O]pen [C]ode ask',
      mode = 'n',
    },
    {
      '<leader>oc',
      function()
        require('opencode').ask('@this', { submit = false })
      end,
      desc = '[O]pen [C]ode ask selection',
      mode = 'v',
    },
  },
  opts = {
    auto_fallback_to_enbedded = false,
  },
  config = function()
    require('config.opencode.notifications').setup()
  end,
}
