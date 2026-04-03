# AGENTS.md — nixosModules/services/

System-level daemons and services. A module belongs here if it manages a running system process (`systemd` service, `udev` rule, kernel feature).

## What belongs here vs programs/

- **services/**: background daemons, hardware management, kernel features
  - Examples: pipewire (audio), greetd (login manager), tlp (power), tailscale (network), xremap (input), bolt (Thunderbolt), fwupd (firmware), brightnessctl (backlight), kde-connect, openssh, podman
- **programs/**: system-level CLI tools or programs that require system-level enablement
  - Examples: hyprland (requires system setuid/capabilities), zsh (requires `/etc/shells`), usbutils, agenix

## Current services

| Module | Option path | Description |
|---|---|---|
| bolt.nix | `myModules.services.bolt` | Thunderbolt device management |
| brightnessctl.nix | `myModules.services.brightnessctl` | Screen backlight control |
| fwupd.nix | `myModules.services.fwupd` | Firmware update daemon |
| greetd.nix | `myModules.services.greetd` | Display/login manager (tuigreet) |
| kde-connect.nix | `myModules.services.kde-connect` | KDE Connect service |
| openssh.nix | `myModules.services.openssh` | SSH daemon |
| pipewire.nix | `myModules.services.pipewire` | Audio (PipeWire + PulseAudio compat) |
| podman.nix | `myModules.services.podman` | Container runtime |
| tailscale.nix | `myModules.services.tailscale` | VPN mesh networking |
| tlp.nix | `myModules.services.tlp` | Power management (battery thresholds) |
| xremap.nix | `myModules.services.xremap` | Key remapping |

## Module conventions

```nix
{ config, lib, pkgs, ... }:
let cfg = config.myModules.services.<name>; in
{
  options.myModules.services.<name> = {
    enable = lib.mkEnableOption "<description>";
    # Additional configurable options with sensible defaults
  };
  config = lib.mkIf cfg.enable {
    services.<name>.enable = true;
    # ...
  };
}
```

**Patterns observed**:
- `greetd.nix`: exposes `sessionCommand` option (default: tuigreet with Hyprland). Session type is configurable without touching the module.
- `tlp.nix`: exposes `batteryThresholds.BAT0/BAT1.{start,stop}` and `extraSettings`. Uses `lib.mkMerge` for multiple config blocks.
- `xremap.nix`: exposes `modmaps`, `extraConfig`, `includeDefaults` (CapsLock → Super/Esc remap). Reads `config.userGlobals.username` to add the user to `input`/`uinput` groups.

**Accessing the primary user**: Use `config.userGlobals.username` when the service needs to add the user to a group or create user-specific paths.

**Using flake inputs in services**: Some services reference `inputs.xremap-flake.packages.*` (xremap.nix). Declare `inputs` in the module's argument list and it arrives via `specialArgs`. Note: `inputs.rose-pine-hyprcursor` is used in `nixosModules/shared/stylix.nix`, not in any file under `services/`.

## Adding a new service module

See `skills/new-nixos-module.md`.
