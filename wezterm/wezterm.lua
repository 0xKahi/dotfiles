local wezterm = require('wezterm')

local cyberpunk = require('themes.cyberpunk')

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Apply the Cyberpunk color scheme
config.colors = cyberpunk.colors

-- apply window Frame
config.window_frame = cyberpunk.window_frame

config.default_cursor_style = 'BlinkingBar'

config.font = wezterm.font('JetBrains Mono', { weight = 'Bold' })
config.font_size = 14.0
config.line_height = 1.05
-- config.bold_brightens_ansi_colors = true
config.freetype_load_target = 'Normal'

config.window_background_opacity = 0.85
config.macos_window_background_blur = 30
config.window_decorations = 'RESIZE'
config.adjust_window_size_when_changing_font_size = false
config.window_padding = {
  left = 3,
  right = 3,
  top = 0,
  bottom = 0,
}

config.check_for_updates = false
config.automatically_reload_config = true

config.default_cwd = wezterm.home_dir

-- Override the CMD+T keybinding to always open in the home directory
config.keys = {
  {
    key = 't',
    mods = 'CMD',
    action = wezterm.action({
      SpawnCommandInNewTab = {
        cwd = wezterm.home_dir,
      },
    }),
  },
}

config.mouse_bindings = {
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

return config
