-- Fully disable notifications
package.loaded["naughty.dbus"] = {}

local _dbus = dbus; dbus = nil
local naughty = require("naughty")
dbus = _dbus
