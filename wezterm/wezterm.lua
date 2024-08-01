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

-- Set the color scheme name (optional, but can be useful for debugging)
config.color_scheme = 'Cyberpunk'

-- Other configuration options can be set here
config.font = wezterm.font('JetBrains Mono', { weight = 'Bold', bold = true })
--config.font = wezterm.font('CaskaydiaCove Nerd', { weight = 'Bold', bold = true })
config.font_size = 14.0
config.line_height = 1.05
config.bold_brightens_ansi_colors = true
config.freetype_load_target = 'Normal'

-- Common font rendering settings
--config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }

config.window_decorations = 'RESIZE'

config.window_background_opacity = 0.85
config.macos_window_background_blur = 30

-- config.default_cursor_style = 'BlinkingBlock'
-- Set the default working directory to the home directory
--
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
