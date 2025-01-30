local ascii = require('config.cyberpunk.ascii-art')
return {
  'folke/snacks.nvim',
  lazy = false,
  opts = {
    dashboard = {
      width = 60,
      row = nil, -- dashboard position. nil for center
      col = nil, -- dashboard position. nil for center
      pane_gap = 4, -- empty columns between vertical panes

      preset = {
        pick = nil,
        header = require('utils.misc').random_selector(ascii),
      },
      sections = {
        { section = 'header' },
        { title = 'Recent Files', padding = 1 },
        { section = 'recent_files', padding = 1, limit = 9, cwd = true },
        -- function()
        --   local in_git = require('snacks').git.get_root() ~= nil
        --   local cmds = {
        --     {
        --       icon = ' ',
        --       title = 'Open PRs',
        --       cmd = 'gh pr list -A @me',
        --       key = 'pr',
        --       action = function()
        --         vim.fn.jobstart('gh pr list --web', { detach = true })
        --       end,
        --       height = 7,
        --     },
        --   }
        --   return vim.tbl_map(function(cmd)
        --     return vim.tbl_extend('force', {
        --       pane = 2,
        --       section = 'terminal',
        --       enabled = in_git,
        --       padding = 1,
        --       ttl = 5 * 60,
        --       indent = 3,
        --     }, cmd)
        --   end, cmds)
        -- end,
        { section = 'startup' },
      },
    },
    notifier = {
      enable = true,
      timeout = 3000, -- default timeout in ms
    },
  },

  keys = {
    {
      '<leader>nn',
      function()
        require('snacks').notifier.hide()
      end,
      { desc = '[N]o [N]otification', silent = false, noremap = true },
      mode = { 'n' },
    },
    {
      '<leader>fn',
      function()
        require('snacks').notifier.show_history()
      end,
      { desc = '[F]ind [N]otification', silent = false, noremap = true },
      mode = { 'n' },
    },
    {
      '<leader>gb',
      function()
        require('snacks').gitbrowse()
      end,
      { desc = '[G]it [B]rowse', silent = false, noremap = true },
      mode = { 'n', 'v' },
    },
  },
}
