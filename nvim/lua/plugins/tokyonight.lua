local theme = require('config.cyberpunk.config')

return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  opts = {
    style = 'moon',
    transparent = true,
    styles = {
      -- Style to be applied to different syntax groups
      -- Value is any valid attr-list value for `:help nvim_set_hl`
      comments = {},
      keywords = {},
      functions = {},
      variables = {},
      -- Background styles. Can be "dark", "transparent" or "normal"
      sidebars = 'dark', -- style for sidebars, see below
      floats = 'transparent', -- style for floating windows
    },

    on_colors = function(colors)
      theme.apply_colors(colors)
    end,

    on_highlights = function(highlights, colors)
      theme.apply_highlight(highlights, colors)
    end,

    cache = true,

    plugins = {
      auto = true,
    },
  },
}
