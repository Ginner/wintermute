# AGENTS.md — NixOS Flake Root

## What this repo is

Personal NixOS flake configuration using a modular, bundle-based architecture. Hosts are minimal — they enable a bundle (laptop/desktop/server) and provide host-specific overrides. All reusable configuration lives in `nixosModules/` (system) and `homeManagerModules/` (user).

## Architectural mental model

```
flake.nix
  └── nixosConfigurations.<HOSTNAME>
        ├── specialArgs = { inherit inputs; }
        ├── ./hosts/<HOSTNAME>/configuration.nix    ← host-specific NixOS
        │     ├── imports ../../nixosModules         ← all modules loaded here
        │     ├── imports ../../users/<username>     ← user NixOS config
        │     ├── userGlobals.username = "..."       ← sets the primary user
        │     ├── myModules.<bundle>.enable = true   ← activates a bundle
        │     ├── myModules.*.enable = true/false    ← per-module overrides
        │     └── home-manager.users."<u>" = import ./home.nix
        │
        └── ./hosts/<HOSTNAME>/home.nix             ← host-specific HM
              ├── imports ../../homeManagerModules   ← all HM modules loaded
              ├── imports ../../users/<username>/home.nix ← user HM config
              └── myHomeModules.<bundle>.enable = true
```

**Core invariant**: Provisioning a new host requires ONLY:
1. A new directory under `hosts/<HOSTNAME>/`
2. Optionally a new directory under `users/<username>/`
3. Adding the host to `flake.nix` outputs
— no changes to `nixosModules/` or `homeManagerModules/`

## Flake inputs

| Input | Purpose |
|---|---|
| nixpkgs | nixos-unstable channel |
| home-manager | User environment management |
| agenix | Secret management (age encryption) |
| hyprland | Wayland compositor (from upstream flake) |
| nixvim | Neovim configuration as NixOS/HM module |
| yazi | Terminal file manager (bleeding-edge build) |
| rose-pine-hyprcursor | Cursor theme |
| stylix | System-wide theming (base16) |
| ags | Shell/widget toolkit |
| xremap-flake | Key remapping service |
| taskfinder | Personal tool (Codeberg) |
| walker | Application launcher |

All inputs follow `nixpkgs` via `inputs.nixpkgs.follows = "nixpkgs"`.

## How specialArgs flow

- **NixOS modules**: `specialArgs = { inherit inputs; }` in `flake.nix` → available as `inputs` in any NixOS module that declares `{ ..., inputs, ... }`
- **Home Manager modules**: `home-manager.extraSpecialArgs = { inherit inputs; }` in `hosts/<HOSTNAME>/configuration.nix` → available as `inputs` in HM modules

## Module option conventions

**Option namespace**:
- NixOS: `myModules.<category>.<name>.*` (defined in `nixosModules/`)
- Home Manager: `myHomeModules.<category>.<name>.*` (defined in `homeManagerModules/`)
- Global user: `userGlobals.username` (defined in `nixosModules/default.nix`)

**Standard module pattern** (see any service or program .nix):
```nix
{ config, lib, pkgs, ... }:
let cfg = config.myModules.services.foo; in
{
  options.myModules.services.foo = {
    enable = lib.mkEnableOption "description";
    someOption = lib.mkOption { type = lib.types.str; default = "val"; description = "..."; };
  };
  config = lib.mkIf cfg.enable { ... };
}
```

**Priority rules**:
- `lib.mkDefault` — bundle sets this; host configs win without `mkForce`
- `lib.mkForce` — overrides everything; used sparingly (e.g., server bundle disabling Hyprland)
- `lib.mkIf` — conditional config block

**Never hardcode hostnames or usernames in modules.** Use `config.userGlobals.username` for the primary user in NixOS modules.

## Standard rebuild commands

```bash
sudo nixos-rebuild switch --flake .#BISHOP   # build and activate
sudo nixos-rebuild test --flake .#BISHOP     # test without making boot default
nix flake update                              # update all inputs
nix flake check                              # validate flake
nixfmt **/*.nix                             # format
nix eval .#nixosConfigurations.BISHOP.config.services.greetd.enable  # inspect
```

## Current hosts in flake outputs

- **BISHOP** — only host in `nixosConfigurations`

## Observed conventions

- Bundle files use `lib.mkDefault` on every module enable so hosts can override
- `userGlobals.username` is consumed by `nixosModules/default.nix` for user account creation and by service modules needing the username (e.g., xremap group memberships)
- `inputs.xremap-flake.nixosModules.default` is imported directly in `hosts/BISHOP/configuration.nix` (not via nixosModules)
- agenix is added as both a NixOS module and an HM module in `flake.nix` via `home-manager.sharedModules`
- stylix is added as a NixOS module in `flake.nix`; there is a separate HM-level stylix module (`homeManagerModules/guiPrograms/stylix.nix`)

## Known issues / deviations from ideal architecture

No outstanding known issues.
