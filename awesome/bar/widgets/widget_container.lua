local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi

return function (body)
  return wibox.widget {
    widget = wibox.container.margin,
    left = beautiful.useless_gap * 2,
    right = beautiful.useless_gap * 2,
    {
      widget = wibox.container.background,
      bg = beautiful.widget_container_bg,
      shape = helpers.rrect(beautiful.widget_container_radius),
      shape_border_color = beautiful.widget_container_border_color,
      shape_border_width = beautiful.widget_container_border_width,
      {
        widget = wibox.container.margin,
        top = beautiful.widget_container_border_width + beautiful.useless_gap,
        bottom = beautiful.widget_container_border_width + beautiful.useless_gap,
        left = dpi(15),
        right = dpi(15),
        body,
      },
    },
  }
end
