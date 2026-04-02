# CLAUDE.md — homeManagerModules/

User-level Home Manager modules. Same option-gating philosophy as `nixosModules/` but for the user environment.

## File structure

```
homeManagerModules/
  default.nix       ← imports everything; defines myHomeModules.default and baseline HM config
  laptop.nix        ← HM bundle for laptop users
  cliPrograms/      ← terminal tools with no display dependency
  guiPrograms/      ← GUI programs requiring a display/compositor
  tuiPrograms/      ← terminal UI programs (ncurses, full-screen TUIs)
  services/         ← user-level services (xdg portals, email sync, etc.)
```

## default.nix

Defines `myHomeModules.default.enable` (bool, default true). Gated behind it:
- `home.username = lib.mkDefault "ginner"` ← **hardcoded; override in user's home.nix**
- `home.homeDirectory = lib.mkDefault "/home/ginner"` ← **same**
- `home.preferXdgDirectories = true`
- Default packages: `git`
- Default module enables: `myHomeModules.cliPrograms.{git,ssh,zsh}.enable = mkDefault true`
- `home.sessionVariables.EDITOR = "nvim"`
- `programs.home-manager.enable = true`

## laptop.nix (HM bundle)

`myHomeModules.laptop.enable` enables the following with `mkDefault true`:
- xdg, firefox, hyprland, kitty, zathura, wayland-tools, stylix, kanshi, swayimg, mpv, btop, cli-tools, starship, archive-tools, direnv, walker, yazi

Set to `mkDefault false` (available but opt-in):
- inkscape, kde-connect, latex, ncspot, opencode, neomutt, khard, email-accounts

Direct config set by the bundle (not via module options):
- Laptop-specific packages: taskfinder, newsboat, numbat, pass-wayland, calcurse, imagemagick, pinentry-tty, cheat, ffmpegthumbnailer, poppler
- `stylix.targets.waybar.enable = false` (waybar managed separately)
- `myHomeModules.cliPrograms.ssh.enableControlMaster = true`

## Option convention

```nix
{ config, lib, pkgs, ... }:
let cfg = config.myHomeModules.<category>.<name>; in
{
  options.myHomeModules.<category>.<name> = {
    enable = lib.mkEnableOption "<description>";
    # Additional options
  };
  config = lib.mkIf cfg.enable { ... };
}
```

All `enable` defaults to false unless the bundle sets `mkDefault true`.

## Category breakdown

| Directory | Contains | Requires display? |
|---|---|---|
| cliPrograms/ | Shell tools, terminal emulator, SSH, git | No |
| guiPrograms/ | Firefox, Hyprland, Waybar, Zathura, MPV, etc. | Yes (Wayland) |
| tuiPrograms/ | Neovim (nixvim), btop, yazi, ncspot, neomutt | No |
| services/ | xdg portals, email accounts (mbsync/msmtp) | Mixed |

## Flake modules in HM

These are added via `imports` in `hosts/<HOSTNAME>/home.nix` (not inside homeManagerModules):
- `inputs.nixvim.homeModules.nixvim` — required by the nixvim config
- `inputs.ags.homeManagerModules.default` — for ags widget system
- `inputs.walker.homeManagerModules.walker` — for Walker launcher

They arrive with `extraSpecialArgs = { inherit inputs; }` from `configuration.nix`.

## Known issues

> **Note for developer**

1. **Hardcoded username**: `default.nix` hardcodes `home.username = lib.mkDefault "ginner"`. A new user must override this in their `home.nix`.

2. **waybar.nix is not option-gated**: `homeManagerModules/guiPrograms/waybar.nix` sets `programs.waybar.enable = true` directly with no `myHomeModules.guiPrograms.waybar.enable` option. This means waybar is always on when the HM modules are imported. The `laptop.nix` bundle explicitly disables stylix for waybar (`stylix.targets.waybar.enable = false`).

3. **nixvim/default.nix is not option-gated**: `homeManagerModules/tuiPrograms/nixvim/default.nix` always sets `programs.nixvim.enable = true` with no enable guard. Nixvim is always active.

4. **kanshi placement**: `kanshi` is in `cliPrograms/` but is a Wayland display management daemon. Its host-specific profiles are set directly in `hosts/BISHOP/home.nix` using `services.kanshi.settings`, bypassing any module option.
