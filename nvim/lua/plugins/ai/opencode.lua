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
    -- -- Patch process detection to filter out nil-port processes (fixes v5.0.0 regression)
    -- local process = require('opencode.cli.process')
    -- local orig_get = process.get
    -- process.get = function()
    --   local procs = orig_get()
    --   return vim.tbl_filter(function(p)
    --     return p.port
    --   end, procs)
    -- end

    local tmux = require('config.opencode.tmux').new({})
    vim.g.opencode_opts = {
      server = {
        start = function()
          tmux:start('opencode --port')
        end,
        stop = function()
          tmux:stop()
        end,
        toggle = function()
          tmux:toggle('opencode --port')
        end,
      },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true
  end,
}
