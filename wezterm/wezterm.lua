local wezterm = require('wezterm')

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Dracula'
config.colors = {
  cursor_bg = '#CD974C',
  cursor_border = '#CD974C',
  cursor_fg = 'black',
  tab_bar = {
    background = '#0b0022',
    new_tab = {
      bg_color = '#0b0022',
      fg_color = '#808080',
      intensity = 'Bold',
    },
  },
}
config.use_fancy_tab_bar = false

config.font = wezterm.font('MesloLGS Nerd Font')
config.font_size = 13.0
config.warn_about_missing_glyphs = false

config.use_resize_increments = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 4, -- to compensate for rounded corners
}
config.mouse_wheel_scrolls_tabs = false

config.default_cursor_style = 'SteadyBar'
config.cursor_thickness = '2px'

config.tab_max_width = 20


-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover)
  local min_width = 3
  local max_width = config.tab_max_width

  -- left edge of tab 0
  local SOLID_LEFT_MOST = utf8.char(0x2588)
  -- left edge of tabs 1-N
  local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
  -- right edge of tabs
  local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

  local SUP_IDX = { '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹', '¹⁰', '¹¹',
    '¹²', '¹³', '¹⁴', '¹⁵', '¹⁶', '¹⁷', '¹⁸', '¹⁹', '²⁰' }

  local edge_background = '#0b0022'
  local background = '#000000'
  local foreground = '#ffffff'
  local tab_num_fg = '#f8f8f2'

  if tab.is_active then
    background = '#bd93f9'
    foreground = '#282a36'
    tab_num_fg = '#282a36'
  elseif hover then
    background = '#6272a4'
    foreground = '#f8f8f2'
  else
    background = '#282a36'
    foreground = '#b3b3af'
  end

  local edge_foreground = background

  local title = tab_title(tab)
  local id = SUP_IDX[tab.tab_index + 1]
  local id_length = string.len(id) / 2 -- unicode character gets computed as 2 characters

  local edge_width = 2 + id_length
  title = wezterm.truncate_right(title, max_width - edge_width)
  title = wezterm.pad_right(title, min_width) -- min width

  local left_edge = SOLID_LEFT_ARROW
  if tab.tab_index == 0 then
    left_edge = SOLID_LEFT_MOST
  end

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = left_edge },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Foreground = { Color = tab_num_fg } },
    { Text = id },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)


config.default_cwd = wezterm.home_dir
config.swallow_mouse_click_on_pane_focus = true
config.scrollback_lines = 10000

config.mouse_bindings = {
  -- Change the default click behavior so that it only selects
  -- text and doesn't open hyperlinks
  {
    mods = 'NONE',
    event = { Up = { streak = 1, button = 'Left' } },
    action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
  },
  -- and make CTRL-Click open hyperlinks
  {
    mods = 'CMD',
    event = { Up = { streak = 1, button = 'Left' } },
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
  {
    mods = 'CMD',
    event = { Down = { streak = 1, button = 'Left' } },
    action = wezterm.action.Nop,
  },
}

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
  {
    mods = 'CMD',
    key = '[',
    action = wezterm.action.MoveTabRelative(-1),
  },
  {
    mods = 'CMD',
    key = ']',
    action = wezterm.action.MoveTabRelative(1),
  },
  {
    mods = 'CMD',
    key = 'UpArrow',
    action = wezterm.action.ScrollByLine(-5),
  },
  {
    mods = 'CMD',
    key = 'DownArrow',
    action = wezterm.action.ScrollByLine(5),
  },
}

return config
