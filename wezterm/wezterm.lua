local wezterm = require('wezterm')

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Dracula'

config.font = wezterm.font('MesloLGS Nerd Font')
config.font_size = 13.0

config.keys = {
  {
    key = 'f',
    mods = 'CMD',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = 's',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal,
  },
  {
    key = 's',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical,
  },
}

return config
