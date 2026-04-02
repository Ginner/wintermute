# CLAUDE.md — nixosModules/programs/

System-level program configuration. A module belongs here if it configures a program that requires system-level enablement (setuid bits, PAM integration, `/etc/shells` registration, system-wide capabilities).

## What belongs here vs services/

- **programs/**: CLI tools or desktop programs needing system-level setup but not running as persistent daemons
  - Examples: hyprland (system enables compositor capabilities), zsh (registers in `/etc/shells`), usbutils (udev rules), agenix (CLI tool install)
- **services/**: persistent background daemons managed by systemd

## Current programs

| Module | Option path | Description |
|---|---|---|
| agenix.nix | `myModules.programs.agenix` | Agenix CLI for secret management |
| hyprland.nix | `myModules.programs.hyprland` | Hyprland Wayland compositor |
| usbutils.nix | `myModules.programs.usbutils` | USB device utilities (lsusb etc.) |
| zsh.nix | `myModules.programs.zsh` | ZSH system-level enablement |

## Module conventions

Same pattern as services — see `nixosModules/services/CLAUDE.md`.

**Observed patterns**:
- `hyprland.nix`: uses the Hyprland package from `inputs.hyprland.packages.*`. Sets `services.xremap.withHypr = lib.mkDefault true` as a side effect.
- `agenix.nix`: installs the agenix CLI from `inputs.agenix.packages.*`. Has `installCLI` boolean option (default true).
- `zsh.nix`: likely just enables `programs.zsh.enable = true` at system level; user shell config is in `homeManagerModules/cliPrograms/zsh.nix`.

## Adding a new program module

See `skills/new-nixos-module.md`.
