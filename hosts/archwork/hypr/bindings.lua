-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.
--
-- Ported 2026-08-15 from the pre-Quattro bindings.conf, which is no longer
-- read. Quattro's defaults already cover several of the old bindings at the
-- same keys (Tmux on SUPER+ALT+RETURN, WhatsApp on SUPER+SHIFT+ALT+G,
-- Google Messages on SUPER+SHIFT+CTRL+G, Grok on SUPER+SHIFT+ALT+A,
-- Browser private on SUPER+SHIFT+ALT+B, X / X Post on SUPER+SHIFT+[ALT+]X)
-- — only the deltas live here. Moved by Quattro defaults: ChatGPT is now
-- SUPER+SHIFT+A, Signal SUPER+SHIFT+G, Google Photos SUPER+SHIFT+P.

-- App launchers on the SUPER+SHIFT+ALT layer.
o.bind("SUPER + SHIFT + ALT + N", "Editor", { omarchy = "editor" })
o.bind("SUPER + SHIFT + ALT + T", "Activity", { tui = "btop" })
o.bind("SUPER + SHIFT + ALT + D", "Docker", { tui = "lazydocker" })
o.bind("SUPER + SHIFT + ALT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })
o.bind("SUPER + SHIFT + ALT + W", "Typora", o.launch("typora --enable-wayland-ime"))
o.bind("SUPER + SHIFT + ALT + SLASH", "Passwords", { omarchy = "1password" })
o.bind("SUPER + SHIFT + ALT + C", "Calendar", { webapp = "https://app.hey.com/calendar/weeks/" })
o.bind("SUPER + SHIFT + ALT + E", "Email", { webapp = "https://app.hey.com" })
o.bind("SUPER + SHIFT + ALT + Y", "YouTube", { webapp = "https://youtube.com/" })

-- Quattro puts "File manager (cwd)" here; restore the plain new-window variant.
hl.unbind("SUPER + ALT + SHIFT + F")
o.bind("SUPER + SHIFT + ALT + F", "File manager", o.launch("nautilus --new-window"))

-- Quattro puts a music TUI here; restore Spotify.
hl.unbind("SUPER + SHIFT + ALT + M")
o.bind("SUPER + SHIFT + ALT + M", "Music", { omarchy = "spotify" })

-- Screenshot on the usual key (old omarchy-cmd-screenshot is gone; Quattro's
-- omarchy-capture-screenshot freezes the screen, picks smart/region, saves to
-- ~/Pictures + clipboard, and offers editing in Tensaku via the notification
-- or SUPER+ALT+comma).
o.bind("SUPER + ALT + P", "Screenshot", "omarchy-capture-screenshot")

-- Keep the bare PRINT key quiet, as before. (SUPER+PRINT color picker and
-- SUPER+CTRL+PRINT OCR are new in Quattro and were never unbound — kept.)
hl.unbind("PRINT")
hl.unbind("ALT + PRINT")
