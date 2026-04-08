# AGENTS.md — homeManagerModules/guiPrograms/

GUI programs requiring a Wayland compositor. All modules here assume Hyprland as the compositor unless noted.

## What qualifies as a GUI program here

- Requires a running Wayland compositor to function
- Or: is a desktop component (status bar, screen locker, launcher, notification daemon)
- Or: requires GPU/display for rendering (image/video viewers)

## Current modules

| File | Option path | Description |
|---|---|---|
| ags.nix | `myHomeModules.guiPrograms.ags` | Aylur's GTK Shell (widget system) — enabled by laptop bundle |
| firefox.nix | `myHomeModules.guiPrograms.firefox` | Firefox browser |
| hyprland.nix | `myHomeModules.guiPrograms.hyprland` | Hyprland compositor + hyprlock + hypridle |
| inkscape.nix | `myHomeModules.guiPrograms.inkscape` | Vector graphics editor |
| kde-connect.nix | `myHomeModules.guiPrograms.kde-connect` | KDE Connect HM-side config |
| mpv.nix | `myHomeModules.guiPrograms.mpv` | Video player |
| swayimg.nix | `myHomeModules.guiPrograms.swayimg` | Image viewer (Wayland-native) |
| walker.nix | `myHomeModules.guiPrograms.walker` | Application launcher |
| waybar.nix | `myHomeModules.guiPrograms.waybar` | Status bar for Hyprland |
| zathura.nix | `myHomeModules.guiPrograms.zathura` | PDF/document viewer |

## Wayland/Hyprland-specific conventions

- All GUI modules assume Wayland. X11 compatibility is not a goal.
- Programs that interact with the clipboard use `wl-clipboard` (provided by `cliPrograms/wayland-tools.nix`).
- Screenshot tools: `grim` + `slurp` (also in wayland-tools).
- `hyprland.nix` contains the full Hyprland config including `hyprlock` (screen locker) and `hypridle` (idle management).

## hyprland.nix details

This is the largest and most complex HM module. It contains:
- `wayland.windowManager.hyprland` settings: gaps, borders, input (dk keyboard layout, TrackPoint settings), keybindings, startup exec
- `programs.hyprlock` configuration (screenshot background blur, input field)
- `services.hypridle` configuration (brightness dim → lock → DPMS off → suspend chain)

**Known issue**: Device-specific input settings (TrackPoint sensitivity, touchpad disable) are hardcoded in this module with a TODO comment noting they should be in host configs. These BISHOP-specific settings will apply to any host using this module.

**startupPrograms option**: exposes `startupPrograms` (list of strings, default `["waybar" "mako"]`), wired through to the startup script.

## Stylix theming

There is no HM-level stylix module. `stylix.nixosModules.stylix` (in `flake.nix`) handles all theming via `stylix.homeManagerIntegration.autoImport = true` (the default), which automatically propagates the NixOS theme (scheme, fonts, cursor, image) to all HM-managed programs.

Per-host wallpaper overrides and target toggles are set directly in `hosts/<HOSTNAME>/home.nix`:
```nix
stylix.image = ../../assets/wall.jpeg;
stylix.targets.waybar.enable = false;  # waybar managed manually
```

## waybar.nix

Follows the standard `myHomeModules.guiPrograms.waybar.enable` pattern. The laptop bundle enables it with `mkDefault true`. Exposes an `output` option (default `"eDP-1"`) so hosts can override which monitor waybar is anchored to.

## MIME associations

MIME defaults are set in `homeManagerModules/services/xdg.nix`, not in individual program modules:
- `text/*` → nvim
- `application/pdf` → zathura
- `image/*` → swayimg
- `video/*` → mpv

## Adding a new GUI program module

See `skills/new-home-module.md`.
