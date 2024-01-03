local gears = require("gears")
local gfs = require("gears.filesystem")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/default/"

local theme = {}
theme.font = "CaskaydiaCove Nerd Font 12"
theme.bg = "#1D1F28"
theme.bg_alt = "#1F222B"
theme.fg = "#FDFDFD"
theme.fg_normal = theme.fg
theme.border_normal = "#000000"
theme.border_focus = "#33ccff"
theme.background_dark = theme.bg
theme.background_lighter = theme.bg
theme.red = "#F37F97"
theme.green = "#90CEAA"
theme.yellow = "#e0da37"
theme.blue = "#8897F4"
theme.magenta = "#B043D1"
theme.cyan = "#79E6F3"
theme.orange = "#f1af5f"

theme.titlebar_bg = "#29333d"
theme.titlebar_border = "#040506"

theme.useless_gap = dpi(5)
theme.border_width = dpi(2)

theme.widget_container_bg = "#1F222Bdd"
theme.widget_container_bg_opaque = theme.bg_alt
theme.widget_container_border_color = theme.bg
theme.widget_container_border_width = dpi(2)
theme.widget_container_radius = dpi(8)

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
theme.bg_systray = theme.widget_container_bg

theme.layout_fairh = theme_dir .. "layouts/fairhw.png"
theme.layout_fairv = theme_dir .. "layouts/fairvw.png"
theme.layout_floating = theme_dir .. "layouts/floatingw.png"
theme.layout_magnifier = theme_dir .. "layouts/magnifierw.png"
theme.layout_max = theme_dir .. "layouts/maxw.png"
theme.layout_fullscreen = theme_dir .. "layouts/fullscreenw.png"
theme.layout_tilebottom = theme_dir .. "layouts/tilebottomw.png"
theme.layout_tileleft = theme_dir .. "layouts/tileleftw.png"
theme.layout_tile = theme_dir .. "layouts/tilew.png"
theme.layout_tiletop = theme_dir .. "layouts/tiletopw.png"
theme.layout_spiral = theme_dir .. "layouts/spiralw.png"
theme.layout_dwindle = theme_dir .. "layouts/dwindlew.png"
theme.layout_cornernw = theme_dir .. "layouts/cornernww.png"
theme.layout_cornerne = theme_dir .. "layouts/cornernew.png"
theme.layout_cornersw = theme_dir .. "layouts/cornersww.png"
theme.layout_cornerse = theme_dir .. "layouts/cornersew.png"
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

theme.hotkeys_bg = theme.bg
theme.hotkeys_fg = theme.fg
theme.hotkeys_modifiers_fg = theme.fg
theme.hotkeys_border_color = theme.border_focus
theme.hotkeys_group_margin = dpi(50)
return theme
