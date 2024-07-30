-- Lua
return {
  {
    'folke/twilight.nvim',
    cmd = 'Twilight',
    opts = {
      dimming = {
        alpha = 0.25, -- amount of dimming
        -- we try to get the foreground from the highlight groups or fallback color
        color = { 'Normal', '#c8d3f5' },
        term_bg = '#312954', -- if guibg=NONE, this will be used to calculate text color
        inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
      },
    },
  },
}
