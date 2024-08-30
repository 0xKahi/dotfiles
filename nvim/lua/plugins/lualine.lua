return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = true,
      theme = require('config.lualine_theme'),
      section_separators = { left = '', right = '' },
      component_separators = '|',
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {
        -- {
        --   'buffers',
        --   mode = 2, -- 0: Shows buffer name
        -- },
      },
      lualine_x = {
        {
          require('noice').api.status.command.get,
          cond = require('noice').api.status.command.has,
          color = { fg = '#00FF9C' },
        },
      },
      lualine_y = { 'encoding', 'filetype' },
      lualine_z = { 'progress', 'location' },
    },
    extensions = { 'fzf', 'lazy', 'mason', 'oil', 'trouble' },
  },
}
