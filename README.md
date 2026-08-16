# .dotfiles

Deployed by copying files by hand -- no stow, chezmoi or install script.
Copy `shared/` on every machine, then the matching `hosts/<hostname>/`.

## shared/ -- portable, same on every host

| Repo path                | Copy to                      |
| ------------------------ | ---------------------------- |
| `shared/ghostty/config`  | `~/.config/ghostty/config`   |
| `shared/nvim/`           | `~/.config/nvim/`            |

## hosts/<hostname>/ -- machine-specific, layered on top

Find the hostname with `hostnamectl hostname`.

| Repo path                                  | Copy to                          |
| ------------------------------------------ | -------------------------------- |
| `hosts/archwork/ghostty/config.local`       | `~/.config/ghostty/config.local` |
| `hosts/archwork/hypr/monitors.conf`         | `~/.config/hypr/monitors.conf`   |
| `hosts/archwork/hypr/hyprland.conf`         | `~/.config/hypr/hyprland.conf`   |
| `hosts/macbook/bash/.bash_profile`          | `~/.bash_profile`                |

`shared/ghostty/config` ends with `config-file = ?config.local`, which ghostty
loads *after* the shared file, so host values win. The `?` makes it optional --
a machine with no `config.local` still starts.

## Adding a host

    mkdir -p hosts/$(hostnamectl hostname)/ghostty
    echo 'font-size = 20' > hosts/$(hostnamectl hostname)/ghostty/config.local

## Notes

- `~/.claude` is **not** here. It lives in the private `claude-config` repo,
  which backs up the whole directory. Do not re-add an `agentic/` copy: the two
  drifted apart last time.
- `hosts/archwork/hypr/monitors.conf` is worth re-copying after an Omarchy
  upgrade. Some Omarchy migrations write into `~/.config/hypr/` unconditionally,
  and this file carries a deliberate change (HDR disabled on DP-1).
- `.bash_profile` is macOS-only (Homebrew paths, `/Users/...`, iTerm2), so it
  lives under a host directory rather than `shared/`. `archwork` uses the stock
  Arch three-liner and has nothing worth tracking.
- `shared/nvim/` was synced from `archwork` on 2026-08-13. Editor state
  (`swap/`, `undo/`, `backup/`) and `.bak` files are deliberately not tracked.
- This repo is **public**. Nothing with credentials goes in it.
