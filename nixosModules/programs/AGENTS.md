# AGENTS.md — nixosModules/programs/

System-level program configuration. A module belongs here if it configures a program that requires system-level enablement (setuid bits, PAM integration, `/etc/shells` registration, system-wide capabilities).

## What belongs here vs services/

- **programs/**: CLI tools or desktop programs needing system-level setup but not running as persistent daemons
  - Examples: hyprland (system enables compositor capabilities), zsh (registers in `/etc/shells`), usbutils (udev rules), sops (CLI tool install)
- **services/**: persistent background daemons managed by systemd

## Current programs

| Module | Option path | Description |
|---|---|---|
| sops.nix | `myModules.programs.sops` | sops CLI for secret management |
| hyprland.nix | `myModules.programs.hyprland` | Hyprland Wayland compositor |
| usbutils.nix | `myModules.programs.usbutils` | USB device utilities (lsusb etc.) |
| zsh.nix | `myModules.programs.zsh` | ZSH system-level enablement |

## Module conventions

Same pattern as services — see `nixosModules/services/AGENTS.md`.

**Observed patterns**:
- `hyprland.nix`: uses the Hyprland package from `inputs.hyprland.packages.*`. Sets `services.xremap.withHypr = lib.mkDefault true` as a side effect.
- `sops.nix`: installs `pkgs.sops` CLI. Has `installCLI` boolean option (default true). The sops NixOS module itself (`sops-nix.nixosModules.sops`) is loaded in `flake.nix`, not here — this module just ensures the CLI is on PATH.
- `zsh.nix`: likely just enables `programs.zsh.enable = true` at system level; user shell config is in `homeManagerModules/cliPrograms/zsh.nix`.

## Adding a new program module

See `skills/new-nixos-module.md`.
