-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all
--
-- Ported 2026-08-15 from the pre-Quattro monitors.conf, which is no longer read
-- (Quattro's Hyprland uses the Lua config provider).

local omarchy_gdk_scale = 1.75

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- HDR disabled 2026-08-13: the panel advertises no PQ/HLG EOTF in its EDID (only
-- "Traditional gamma - SDR luminance range") at ~486 nits, so cm,hdr bought BT.2020
-- signalling and nothing else, while costing washed-out screenshots and untuned
-- SDR tone-mapping. bitdepth 10 is kept for gradient banding. To re-enable, add
-- cm = "hdr" to the DP-1 spec — BUT hdr-resume-fix greps the old monitors.conf
-- for the literal "cm,hdr" token, so update /usr/local/bin/hdr-resume-fix to
-- read this file first or the post-resume re-commit will never fire.
hl.monitor({ output = "DP-1", mode = "3840x2160@160", position = "0x0", scale = 1.666667, bitdepth = 10 })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1.666667 })

-- Workspaces 1-4 on DP-1 (Acer), 5-6 on HDMI-A-1 (Samsung).
for _, ws in ipairs({ "1", "2", "3", "4" }) do
  hl.workspace_rule({ workspace = "name:" .. ws, monitor = "DP-1" })
end
for _, ws in ipairs({ "5", "6" }) do
  hl.workspace_rule({ workspace = "name:" .. ws, monitor = "HDMI-A-1" })
end

o.exec_on_start("hyprctl dispatch workspace 1")
