local cyberpunk = require('config.cyberpunk.colors')

return {
  'rachartier/tiny-glimmer.nvim',
  event = 'TextYankPost',
  opts = {
    enabled = true,
    default_animation = 'fade',
    refresh_interval_ms = 6,

    -- Only use if you have a transparent background
    -- It will override the highlight group background color for `to_color` in all animations
    transparency_color = cyberpunk.core.bg,
    animations = {
      fade = {
        from_color = cyberpunk.core.bright_magenta,
      },
    },
  },
}
