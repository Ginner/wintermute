# CLAUDE.md — homeManagerModules/guiPrograms/

GUI programs requiring a Wayland compositor. All modules here assume Hyprland as the compositor unless noted.

## What qualifies as a GUI program here

- Requires a running Wayland compositor to function
- Or: is a desktop component (status bar, screen locker, launcher, notification daemon)
- Or: requires GPU/display for rendering (image/video viewers)

## Current modules

| File | Option path | Description |
|---|---|---|
| ags.nix | `myHomeModules.guiPrograms.ags` | Aylur's GTK Shell (widget system) |
| firefox.nix | `myHomeModules.guiPrograms.firefox` | Firefox browser |
| hyprland.nix | `myHomeModules.guiPrograms.hyprland` | Hyprland compositor + hyprlock + hypridle |
| inkscape.nix | `myHomeModules.guiPrograms.inkscape` | Vector graphics editor |
| kde-connect.nix | `myHomeModules.guiPrograms.kde-connect` | KDE Connect HM-side config |
| mpv.nix | `myHomeModules.guiPrograms.mpv` | Video player |
| stylix.nix | `myHomeModules.guiPrograms.stylix` | HM-level Stylix theming |
| swayimg.nix | `myHomeModules.guiPrograms.swayimg` | Image viewer (Wayland-native) |
| walker.nix | `myHomeModules.guiPrograms.walker` | Application launcher |
| waybar.nix | *(no option gate)* | Status bar for Hyprland |
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

**startupPrograms option**: exposes `startupPrograms` (list of strings, default `["waybar" "mako"]`) but the actual startup script uses the same two hardcoded programs. The option is not wired through.

## stylix.nix (HM-level)

Separate from `nixosModules/shared/stylix.nix`. Exposes:
- `enable` (mkEnableOption)
- `image` (path, default `../../assets/default.jpg`)

Uses catppuccin-frappe color scheme (different from the system-level google-dark default). BISHOP overrides `image` in `hosts/BISHOP/home.nix`.

**Note**: Both NixOS-level and HM-level Stylix modules are active on BISHOP. This works because Stylix supports both levels, but the NixOS-level settings take precedence for system-level targets.

## waybar.nix — not option-gated

`waybar.nix` does not follow the `myHomeModules.*.enable` pattern. It directly sets `programs.waybar.enable = true` and provides a full config. Adding this module to the import list unconditionally activates waybar. This is inconsistent with all other modules. The laptop bundle explicitly disables Stylix for waybar (`stylix.targets.waybar.enable = false`).

The waybar config is hardcoded for BISHOP (output = `"eDP-1"`).

## MIME associations

MIME defaults are set in `homeManagerModules/services/xdg.nix`, not in individual program modules:
- `text/*` → nvim
- `application/pdf` → zathura
- `image/*` → swayimg
- `video/*` → mpv

## Adding a new GUI program module

See `skills/new-home-module.md`.
