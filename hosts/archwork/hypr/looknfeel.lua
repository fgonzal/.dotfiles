-- Change the default Omarchy look'n'feel.
--
-- Ported 2026-08-15 from the pre-Quattro looknfeel.conf, which is no longer read.

-- Override Omarchy's default per-window opacity (windows.lua sets 0.985/0.96)
-- so both active and inactive windows are fully opaque. Loaded after the
-- defaults, so this rule wins.
o.window(".*", { opacity = "1.0 1.0" })
