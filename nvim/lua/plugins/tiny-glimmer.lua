return {
  'rachartier/tiny-glimmer.nvim',
  event = 'TextYankPost',
  opts = {
    enabled = true,
    default_animation = 'fade',
    refresh_interval_ms = 6,

    -- Only use if you have a transparent background
    -- It will override the highlight group background color for `to_color` in all animations
    transparency_color = '#312954',
    animations = {
      fade = {
        from_color = '#3d5afe',
        to_color = '#2d3f76',
      },
    },
  },
}
