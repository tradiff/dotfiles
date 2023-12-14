local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}
theme.systray_icon_spacing = 5

theme.font = "CaskaydiaCove Nerd Font 12"

theme.fg = "#a9b1d6"
theme.bg = "#24283b"
theme.bg_normal = "#24283b"
theme.fg_normal = "#a9b1d6"
theme.bg_focus = "#535d6c"
theme.fg_focus = "#a9b1d6"
theme.border_width = 1
theme.border_normal = "#000000"
theme.border_focus = "#33ccff"
theme.background_dark = "#1a1b26"
theme.background_lighter = "#24283b"
theme.white = "#a9b1d6"
theme.blueish_white = "#89b4fa"
theme.red = "#F7768E"
theme.green = "#73daca"
theme.yellow = "#E0AF68"
theme.blue = "#7AA2F7"
theme.magenta = "#BB9AF7"
theme.cyan = "#7dcfff"
theme.bg_systray = theme.background_light


theme.useless_gap = dpi(5)
theme.border_width = dpi(2)

theme.taglist_bg_empty = theme.background_light
theme.taglist_fg_empty = theme.white
theme.taglist_bg_occupied = theme.background_light
theme.taglist_fg_occupied = theme.white
theme.taglist_fg_focus = theme.background_dark
theme.taglist_bg_focus = theme.cyan
theme.taglist_bg_urgent = theme.red
theme.taglist_fg_urgent = "#00000080"
-- Other Taglist settings
theme.taglist_spacing = 0
theme.taglist_shape_border_width = 3

theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"


-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

theme.notification_font = "Ubuntu Nerd Font 14"
theme.notification_fg = "#a9b1d6"
theme.notification_position = "top_right"
theme.notification_margin = dpi(10)
theme.notification_border_width = dpi(0)
theme.notification_spacing = dpi(15)
theme.notification_icon_resize_strategy = "center"
theme.notification_icon_size = dpi(300)

--Shortcut key list popup theme
theme.hotkeys_font = "Ubuntu Nerd font bold 12"
theme.hotkeys_description_font = "Ubuntu nerd font 12"
theme.hotkeys_group_margin = dpi(20)
theme.hotkeys_modifiers_fg = theme.blueish_white

return theme
