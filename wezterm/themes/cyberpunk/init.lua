local M = {}

-- Helper function to convert RGB components to hex
-- local function rgb_to_hex(r, g, b)
--   return string.format('#%02X%02X%02X', math.floor(r * 255), math.floor(g * 255), math.floor(b * 255))
-- end

M.colors = {
  foreground = '#E5E5E5',
  background = '#312954',
  cursor_bg = '#74F27E',
  cursor_fg = 'black',
  cursor_border = '#74F27E',
  selection_fg = 'none',
  selection_bg = '#311b92',

  ansi = {
    '#000000',
    '#ED7892',
    '#72F6B2',
    '#FDF980',
    '#55BBF9',
    '#D498F8',
    '#95C9F8',
    '#FEFFFF',
  },

  brights = {
    '#000000',
    '#EF8FA4',
    '#74F2BF',
    '#FDF796',
    '#5FC8F7',
    '#DDAFF8',
    '#A6D4F8',
    '#FEFEFE',
  },

  compose_cursor = 'orange',

  tab_bar = {
    inactive_tab_edge = '#504a6b',
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = '#241d47',

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = '#312954',
      -- The color of the text for the tab
      fg_color = '#E5E5E5',

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = 'Normal',

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = 'None',

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = '#241d47',
      fg_color = 'rgba(50% 50% 50% 50%)',
      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },
    --
    --   -- You can configure some alternate styling when the mouse pointer
    --   -- moves over inactive tabs
    --   inactive_tab_hover = {
    --     bg_color = '#3b3052',
    --     fg_color = '#909090',
    --     italic = true,
    --
    --     -- The same options that were listed under the `active_tab` section above
    --     -- can also be used for `inactive_tab_hover`.
    --   },
    --
    --   -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = '#241d47',
      fg_color = '#E5E5E5',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },
    --
    --   -- You can configure some alternate styling when the mouse pointer
    --   -- moves over the new tab button
    --   new_tab_hover = {
    --     bg_color = '#3b3052',
    --     fg_color = '#909090',
    --     italic = true,
    --
    --     -- The same options that were listed under the `active_tab` section above
    --     -- can also be used for `new_tab_hover`.
    --   },
  },
}

M.window_frame = {
  -- font = { family = 'JetBrains Mono', weight = 'Bold' },

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 14.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = '#322a54',

  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = '#241d47',
}

return M
