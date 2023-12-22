local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local wibox = require("wibox")

return function (screen)
  return {
    awful.widget.layoutbox(screen),
    forced_height = beautiful.layout_image_size,
    forced_width = beautiful.layout_image_size,
    layout = wibox.container.place,
    valign = "center",
    halign = "center",
    buttons = gears.table.join(
      awful.button({}, helpers.mouse.MB_LEFT, function () awful.layout.inc(1) end),
      awful.button({}, helpers.mouse.MB_RIGHT, function () awful.layout.inc(-1) end)
    ),
  }
end
