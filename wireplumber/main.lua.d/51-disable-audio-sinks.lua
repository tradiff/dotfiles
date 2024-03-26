local add_rule = function(rule)
  table.insert(alsa_monitor.rules, rule)
end

local set_nick = function(name, nick)
  add_rule({
    matches = {
      { { "node.name", "equals", name }, },
    },
    apply_properties = {
      ["node.nick"] = nick,
      ["node.description"] = nick,
    },
  })
end

-- disable DisplayPort1, DisplayPort2, DisplayPort3
add_rule({
  matches = {
    { { "node.name", "equals", "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_3__sink" }, },
    { { "node.name", "equals", "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_4__sink" }, },
    { { "node.name", "equals", "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_5__sink" }, },
  },
  apply_properties = {
    ["node.disabled"] = true,
  },
})


-- More friendly names
set_nick("alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink",
  "Laptop Speakers / Headphones")
set_nick("alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__source", "Headset Microphone")
set_nick("alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_6__source", "Laptop Microphone")
