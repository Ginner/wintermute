# AGENTS.md — nixosModules/

System-level NixOS modules. All modules are imported unconditionally by `default.nix` but are **opt-in by default** — each module's config block is gated behind an `enable` option.

## File structure

```
nixosModules/
  default.nix       ← imports everything; defines userGlobals and myModules.default
  laptop.nix        ← bundle: enables groups of modules for a laptop
  desktop.nix       ← bundle: enables groups of modules for a desktop
  server.nix        ← bundle: enables groups of modules for a server
  services/         ← daemon-level services; imported via services/default.nix (see services/AGENTS.md)
  programs/         ← system-level program configs; imported via programs/default.nix (see programs/AGENTS.md)
  shared/
    stylix.nix      ← system-wide theming via Stylix (base16)
```

## default.nix

Defines two global option groups and a default config block:

**`userGlobals.username`** (`lib.types.str`, default `"nixos"`):
Used throughout modules to reference the primary user (e.g., `users.users.${user}`, group membership). Every host must set `userGlobals.username = "<username>"`.

**`myModules.default.enable`** (`bool`, default `true`):
Gates the baseline NixOS configuration applied to all systems:
- User account creation with wheel group
- Nix settings: flakes, auto-optimise, trusted-users, weekly GC
- systemd-boot + EFI
- Timezone `Europe/Copenhagen`, locale `da_DK.UTF-8`, keymap `dk` (all `mkDefault` — overridable)
- Minimal system packages: `file`, `which`, `lm_sensors`
- openssh enabled by default (`mkDefault`)
- neovim as default editor
- zsh enabled system-wide (`mkDefault`)

## Bundle modules

Bundles (`laptop.nix`, `desktop.nix`, `server.nix`) set module enables using `lib.mkDefault true` — hosts can override any of these. Bundles never duplicate configuration from individual modules; they only flip their `enable` switches.

### laptop.nix (`myModules.laptop`)

Options: `enableThermald` (default true), `enableTouchpad` (default true)

Enables: tlp, pipewire, greetd, brightnessctl, bolt, fwupd, xremap, stylix, agenix, hyprland, usbutils

Direct config (not via modules): networkmanager, upower, acpid, bluetooth, libinput, CPU-specific packages (`ryzenadj` for AMD, `powertop` for Intel), `acpi`, `powerstat`

### desktop.nix (`myModules.desktop`)

Options: `enableGaming` (default false), `enableMultiMonitor` (default true), `enableGraphicsTools` (default true)

Enables: pipewire, greetd, brightnessctl, fwupd, stylix, hyprland, usbutils

Direct config: hardware.graphics, dbus, udisks2, gvfs, fonts

### server.nix (`myModules.server`)

Options: `enableContainers`, `enableWebServer`, `enableDatabase`, `enableMonitoring`, `enableBackups`, `enableFirewall`

Enables: tailscale, podman (if enableContainers), usbutils

Direct config: openssh (hardened), nginx/postgresql/prometheus (conditional), firewall, security hardening, auto-upgrade (disabled by default)

Explicitly disables: `services.xserver`, `programs.hyprland` via `mkForce false`

## Module option convention

Every individual module (`services/*.nix`, `programs/*.nix`) follows:

```nix
{ config, lib, pkgs, ... }:
let cfg = config.myModules.<category>.<name>; in
{
  options.myModules.<category>.<name> = {
    enable = lib.mkEnableOption "<description>";
    # Additional options with defaults
  };
  config = lib.mkIf cfg.enable { ... };
}
```

All `enable` options default to `false` unless a bundle sets them `mkDefault true`.

## Never put host-specific config in modules

Modules must work for any host. No hardcoded:
- Hostnames
- Usernames (use `config.userGlobals.username`)
- File paths outside the store
- Hardware-specific assumptions (detect via `config.hardware.cpu.*`)

## Import pattern

`default.nix` imports `./services`, `./programs`, `./shared/stylix.nix`, and the three bundle files. Services and programs are each collected by their own `default.nix`.

Adding a new module requires two steps:
1. Create the `.nix` file under `services/` or `programs/`
2. Add it to the relevant `services/default.nix` or `programs/default.nix`

Hosts do NOT import individual modules — they import `../../nixosModules` and everything comes in.

## Known issues / notes

No outstanding known issues.
