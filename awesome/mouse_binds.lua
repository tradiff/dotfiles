local awful = require("awful")
local gears = require("gears")
local helpers = require("helpers")
local modkey = helpers.key.MOD


local client_mouse_binds = gears.table.join(
  awful.button({}, helpers.mouse.MB_LEFT, function (c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
  end),
  awful.button({ modkey, }, helpers.mouse.MB_LEFT, function (c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey, }, helpers.mouse.MB_RIGHT, function (c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
    awful.mouse.client.resize(c)
  end),
  -- modkey + Alt + Left Click drag to resize
  awful.button({ modkey, helpers.key.ALT, }, helpers.mouse.MB_LEFT, function (c)
    c:emit_signal("request::activate", "mouse_click", { raise = true, })
    awful.mouse.client.resize(c)
  end)
)

return {
  client = client_mouse_binds,
}
