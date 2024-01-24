local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")

return function (screen)
  awful.tag(
    { " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 ", },
    screen,
    awful.layout.layouts[1]
  )

  return awful.widget.taglist {
    screen = screen,
    filter = function (t) return t.selected or #t:clients() > 0 end,
    style = {
      shape = helpers.rrect(beautiful.widget_container_radius),
      shape_border_width = 0,
    },

    buttons = gears.table.join(
    -- left click to view tag
      awful.button({}, helpers.mouse.MB_LEFT, function (t) t:view_only() end),
      -- mod + left click to send the focused client to the tag
      awful.button({ helpers.key.MOD, }, helpers.mouse.MB_LEFT, function (t)
        if client.focus then
          client.focus:move_to_tag(t)
        end
      end),
      -- right click to toggle
      awful.button({}, helpers.mouse.MB_RIGHT, awful.tag.viewtoggle)
    ),
  }
end
