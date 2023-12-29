local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local hotkeys_popup = require("awful.hotkeys_popup.keys")
local modkey = helpers.key.MOD
local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")

local global_keys = gears.table.join(
  awful.key({ modkey, }, "s", hotkeys_popup.show_help,
    { description = "show help", group = "awesome", }),
  awful.key({ modkey, }, "Left", function () helpers.switch_tag(-1) end),
  awful.key({ modkey, }, "Right", function () helpers.switch_tag(1) end),
  awful.key({ modkey, }, "Up", helpers.switch_new_tag),
  awful.key({ modkey, }, "Escape", awful.tag.history.restore,
    { description = "go back", group = "tag", }
  ),
  awful.key({ modkey, }, "j", function () awful.client.focus.byidx(1) end,
    { description = "focus next by index", group = "client", }
  ),
  awful.key({ modkey, }, "k", function () awful.client.focus.byidx(-1) end,
    { description = "focus previous by index", group = "client", }
  ),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey, }, "Tab",
    function ()
      awful.client.focus.history.previous()
      if client.focus then
        client.focus:raise()
      end
    end,
    { description = "go back", group = "client", }
  ),

  awful.key({ modkey, }, "Return", function () awful.spawn("wezterm") end,
    { description = "open a terminal", group = "launcher", }
  ),
  awful.key({ modkey, }, "r", function ()
      awful.spawn.with_shell("killall rofi || rofi -show combi")
    end,
    { description = "run prompt", group = "launcher", }
  ),

  awful.key({ modkey, "Control", }, "r", awesome.restart,
    { description = "reload awesome", group = "awesome", }
  ),
  awful.key({ modkey, }, "l", function () awful.tag.incmwfact(0.05) end,
    { description = "increase master width factor", group = "layout", }
  ),
  awful.key({ modkey, }, "h", function () awful.tag.incmwfact(-0.05) end,
    { description = "decrease master width factor", group = "layout", }
  ),
  awful.key({ modkey, "Shift", }, "h", function () awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout", }),
  awful.key({ modkey, "Shift", }, "l", function () awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout", }),
  awful.key({ modkey, "Control", }, "Up", function () awful.tag.incncol(1, nil, true) end,
    { description = "increase the number of columns", group = "layout", }),
  awful.key({ modkey, "Control", }, "Down", function () awful.tag.incncol(-1, nil, true) end,
    { description = "decrease the number of columns", group = "layout", }),
  awful.key({ modkey, }, "space", function () awful.layout.inc(1) end,
    { description = "select next", group = "layout", }),
  awful.key({ modkey, "Shift", }, "space", function () awful.layout.inc(-1) end,
    { description = "select previous", group = "layout", }),

  awful.key({ modkey, "Control", }, "n",
    function ()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal(
          "request::activate", "key.unminimize", { raise = true, }
        )
      end
    end,
    { description = "restore minimized", group = "client", }),


  -- media
  awful.key({}, "XF86AudioRaiseVolume",
    function () helpers.change_volume(1) end
  ),
  awful.key({}, "XF86AudioLowerVolume",
    function () helpers.change_volume(-1) end
  ),
  awful.key({}, "XF86AudioMute",
    function () awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle") end
  ),
  awful.key({}, "XF86MonBrightnessUp",
    function () helpers.change_brightness(1) end
  ),
  awful.key({}, "XF86MonBrightnessDown",
    function () helpers.change_brightness(-1) end
  ),
  awful.key({}, "Print",
    function () awful.util.spawn("flameshot gui") end
  ),
  awful.key({}, "XF86PowerOff",
    function ()
      logout_popup.launch({
        icon_size = 40,
        icon_margin = 16,
        bg_color = beautiful.bg,
        accent_color = "#ff79c6",
        text_color = beautiful.fg,
        label_color = beautiful.fg,
        onlock = function () awful.spawn.with_shell("betterlockscreen --lock dim") end,
      })
    end
  ),
  awful.key({ modkey, }, "F12", function ()
      local screen = awful.screen.focused()
      if screen.padding.bottom == 0 then
        screen.padding = { bottom = 200, }
      else
        screen.padding = { bottom = 0, }
      end
    end,
    { description = "Toggle bottom screen padding", group = "layout", }
  )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  global_keys = gears.table.join(global_keys,
    -- View tag only mod+num
    awful.key({ modkey, }, "#" .. i + 9,
      function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      { description = "view tag #" .. i, group = "tag", }),

    -- Move client to tag mod+shift+num
    awful.key({ modkey, "Shift", }, "#" .. i + 9,
      function ()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then
            client.focus:move_to_tag(tag)
          end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag", })
  )
end

local client_keys = gears.table.join(
  awful.key({ modkey, }, "f",
    function (c)
      c.maximized = not c.maximized
      c:raise()
    end),
  awful.key({ modkey, }, "q", function (c) c:kill() end),
  awful.key({ modkey, "Control", }, "space", awful.client.floating.toggle),
  awful.key({ modkey, }, "t", function (c) c.ontop = not c.ontop end,
    { description = "toggle keep on top", group = "client", }
  ),
  awful.key({ modkey, }, "n", function (c) c.minimized = true end,
    { description = "minimize", group = "client", }
  )
)

return {
  global = global_keys,
  client = client_keys,
}
