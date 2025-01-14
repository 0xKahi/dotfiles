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
