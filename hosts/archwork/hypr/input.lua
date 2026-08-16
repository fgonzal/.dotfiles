-- Keep only your personal input overrides here. Uncommented settings below
-- replace Omarchy's defaults.
--
-- Ported 2026-08-15 from the pre-Quattro input.conf, which is no longer read.

hl.config({
  input = {
    -- Compose key on Caps Lock.
    kb_options = "compose:caps",

    -- Change speed of keyboard repeat.
    repeat_rate = 40,
    repeat_delay = 300,

    -- Start with numlock on by default.
    numlock_by_default = true,

    touchpad = {
      -- Control the speed of your scrolling.
      scroll_factor = 0.4,
    },
  },
})
