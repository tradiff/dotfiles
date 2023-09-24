local wezterm = require('wezterm')

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Dracula'

config.font = wezterm.font('MesloLGS Nerd Font')
config.font_size = 13.0
config.warn_about_missing_glyphs = false

config.use_resize_increments = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 4, -- to compensate for rounded corners
}
config.mouse_wheel_scrolls_tabs = false

config.default_cursor_style = 'SteadyBar'


config.default_cwd = wezterm.home_dir
config.swallow_mouse_click_on_pane_focus = true

config.keys = {
  {
    mods = 'CMD',
    key = 'f',
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    mods = 'CMD',
    key = 's',
    action = wezterm.action.SplitHorizontal,
  },
  {
    mods = 'CMD|SHIFT',
    key = 's',
    action = wezterm.action.SplitVertical,
  },
  {
    mods = 'CMD',
    key = 'k',
    action = wezterm.action.ClearScrollback('ScrollbackAndViewport'),
  },
  {
    mods = 'CMD',
    key = 't',
    action = wezterm.action.SpawnCommandInNewTab({
      cwd = wezterm.home_dir
    }),
  },

}

return config
