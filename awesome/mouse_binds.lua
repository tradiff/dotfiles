local gears = require("gears")
local awful = require("awful")
local modkey = "Mod4"

local client_mouse_binds = gears.table.join(
  awful.button({}, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
  end),
  awful.button({ modkey, }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey, }, 3, function (c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
    awful.mouse.client.resize(c)
  end),
  -- modkey + Alt + Left Click drag to resize
  awful.button({ modkey, "Mod1", }, 1, function (c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
    awful.mouse.client.resize(c)
  end)
)

return {
  client = client_mouse_binds,
}
