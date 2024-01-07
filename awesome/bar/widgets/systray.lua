local beautiful = require("beautiful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi

return function ()
  local widget = {
    widget = wibox.container.margin,
    margins = dpi(4),

    {
      widget = wibox.widget.systray,
    },
  }

  return widget
end
