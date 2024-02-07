local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
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
        "zoom",
      },
      name = {
      },
      role = {
      },
    },
    properties = {
      sticky = false,
      ontop = true,
      floating = true,
    },
  },
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
        "pop-up",
      },
    },
    properties = {
      sticky = true,
      ontop = true,
      floating = true,
    },
  },
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
  c.shape = helpers.rrect(beautiful.client_border_radius)

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

local update_border = function (c)
  if c.active and c.maximized then
    c.border_color = beautiful.green
  elseif c.active and c.floating then
    c.border_color = beautiful.magenta
  elseif c.active then
    c.border_color = beautiful.border_focus
  else
    c.border_color = beautiful.border_normal
  end
  c.border_width = beautiful.border_width
end

local maybe_show_titlebar = function (c)
  if c.floating and not c.maximized then
    awful.titlebar.show(c)
  else
    awful.titlebar.hide(c)
  end
end

-- focus follows mouse
client.connect_signal("mouse::enter", function (c)
  c:emit_signal("request::activate", "mouse_enter", { raise = false, })
end)

client.connect_signal("property::active", update_border)
client.connect_signal("property::floating", update_border)
client.connect_signal("property::maximized", update_border)

client.connect_signal("property::floating", maybe_show_titlebar)
client.connect_signal("property::maximized", maybe_show_titlebar)

-- turn tilebars on when layout is floating
awful.tag.attached_connect_signal(nil, "property::layout",
  function (t)
    local float = t.layout.name == "floating"
    for _, c in pairs(t:clients()) do c.floating = float end
  end
)

-- fix titlebars causing bottom of full screen apps to be cut off
client.connect_signal("property::fullscreen", function (c)
  if c.fullscreen then
    gears.timer.delayed_call(function ()
      if c.valid then
        c:geometry(c.screen.geometry)
      end
    end)
  end
end)
