local beautiful = require("beautiful")
local awful = require("awful")
local key_binds = require("key_binds")
local mouse_binds = require("mouse_binds")

awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = key_binds.client,
      buttons = mouse_binds.client,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
      },
      class = {
        "Pavucontrol",
        "Blueman-manager",
      },
      name = {
        "Picture in picture",
      },
      role = {
      },
    },
    properties = { floating = true, },
  },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- focus follows mouse
client.connect_signal("mouse::enter", function (c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false, })
end)
