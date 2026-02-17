return {
  'NickvanDyke/opencode.nvim',
  -- commit = '08bf7763fe1f363a70c6a84f6bbb82fe111da8b5', -- commit hash before v1.0.0 release
  dependencies = { 'folke/snacks.nvim' },
  version = '*',
  keys = {
    {
      '<leader>oc',
      function()
        require('opencode').ask('', { ask = true })
      end,
      desc = '[O]pen [C]ode ask',
      mode = 'n',
    },
    {
      '<leader>oc',
      function()
        require('opencode').ask('@this', { ask = true })
      end,
      desc = '[O]pen [C]ode ask selection',
      mode = 'v',
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      provider = {
        enabled = 'tmux',
        tmux = {},
      },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true
  end,
}
