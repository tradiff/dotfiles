local gears = require("gears")
local gfs = require("gears.filesystem")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local themes_path = gfs.get_themes_dir()

local theme = {}
theme.font = "CaskaydiaCove Nerd Font 12"
theme.bg = "#1D1F28"
theme.bg_alt = "#1F222B"
theme.fg = "#FDFDFD"
theme.border_normal = "#000000"
theme.border_focus = "#33ccff"
theme.background_dark = theme.bg
theme.background_lighter = theme.bg
theme.red = "#F37F97"
theme.green = "#90CEAA"
theme.yellow = "#F2A272"
theme.blue = "#8897F4"
theme.magenta = "#B043D1"
theme.cyan = "#79E6F3"

theme.useless_gap = dpi(5)
theme.border_width = dpi(2)

theme.segment_bg = "#1F222Bdd"
theme.segment_border_color = theme.bg
theme.segment_border_width = dpi(2)
theme.segment_radius = dpi(8)

theme.wibar_bg = "#00000000" -- fully transparent

theme.taglist_spacing = 0
theme.taglist_shape_border_width = 3
theme.taglist_bg_empty = theme.background_light
theme.taglist_fg_empty = theme.white
theme.taglist_bg_occupied = theme.background_light
theme.taglist_fg_occupied = theme.white
theme.taglist_bg_focus = theme.cyan
theme.taglist_fg_focus = "#000000aa"
theme.taglist_bg_urgent = theme.red
theme.taglist_fg_urgent = "#000000aa"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil
theme.systray_icon_spacing = 5
theme.systray_icon_size = dpi(16)
theme.bg_systray = theme.segment_bg

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
theme.layout_image_size = dpi(16)

theme.notification_font = "Ubuntu Nerd Font 14"
theme.notification_fg = theme.fg
theme.notification_position = "top_right"
theme.notification_margin = dpi(10)
theme.notification_border_width = dpi(0)
theme.notification_spacing = dpi(15)
theme.notification_icon_resize_strategy = "center"
theme.notification_icon_size = dpi(300)
theme.notification_width = dpi(300)

naughty.config.defaults.shape = function (cr, w, h)
  gears.shape.rounded_rect(cr, w, h, dpi(6))
end

-- Apply theme variables
naughty.config.padding = dpi(8)
naughty.config.spacing = dpi(8)
naughty.config.icon_dirs = {
  "/usr/share/icons/Papirus-Dark/",
}
naughty.config.icon_formats = { "svg", "png", "jpg", "gif", }

theme.client_border_radius = dpi(8)

return theme
