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

  -- systray cannot be transparent so it's container also needs to be not
  -- transparent or it'll look weird.
  widget.bg = beautiful.widget_container_bg_opaque

  return widget
end
