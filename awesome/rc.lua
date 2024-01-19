pcall(require, "luarocks.loader")
local beautiful = require("beautiful")
beautiful.init("~/.config/awesome/themes/default/theme.lua")

require("awful.autofocus")
require("bar")
require("client_rules")
local naughty = require("naughty")
local key_binds = require("key_binds")
require("remember_tag")
require("titlebar")
require("notifications")

if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors,
  })
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err),
    })
    in_error = false
  end)
end

root.keys(key_binds.global)
