local ascii = require('config.cyberpunk.ascii-art')
return {
  'folke/snacks.nvim',
  opts = {
    dashboard = {
      width = 60,
      row = nil, -- dashboard position. nil for center
      col = nil, -- dashboard position. nil for center
      pane_gap = 4, -- empty columns between vertical panes

      preset = {
        pick = nil,
        header = ascii.anime_eyes,
      },
      sections = {
        { section = 'header' },
        { title = 'Recent Files', padding = 1 },
        { section = 'recent_files', padding = 1, cwd = true },
        { section = 'startup' },
      },
    },
  },
}
