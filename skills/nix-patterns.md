# Skill: Nix patterns used in this repo

A reference for Nix/NixOS idioms as actually used here. Not a tutorial — consult the NixOS manual for basics.

---

## Option declaration patterns

### mkEnableOption

```nix
enable = lib.mkEnableOption "Human-readable description";
# Equivalent to:
enable = lib.mkOption {
  type = lib.types.bool;
  default = false;
  description = "Whether to enable Human-readable description.";
};
```

Always use `mkEnableOption` for `enable` options. Default is `false`.

### mkOption with common types

```nix
# String
port = lib.mkOption {
  type = lib.types.str;
  default = "value";
  description = "...";
};

# Integer
size = lib.mkOption {
  type = lib.types.int;
  default = 42;
};

# Boolean
flag = lib.mkOption {
  type = lib.types.bool;
  default = true;
};

# Path (Nix store path)
image = lib.mkOption {
  type = lib.types.path;
  description = "Path to image file";
  # No default if required
};

# Enum
polarity = lib.mkOption {
  type = lib.types.enum [ "light" "dark" ];
  default = "dark";
};

# Attribute set of anything (passthrough)
matchBlocks = lib.mkOption {
  type = lib.types.attrsOf (lib.types.anything);
  default = {};
};

# List of submodules (from xremap.nix)
modmaps = lib.mkOption {
  type = lib.types.listOf (lib.types.submodule {
    options = {
      name = lib.mkOption { type = lib.types.str; };
      remap = lib.mkOption { type = lib.types.attrsOf lib.types.anything; };
    };
  });
  default = [];
};

# Lines (for multi-line strings, appended)
extraConfig = lib.mkOption {
  type = lib.types.lines;
  default = "";
};
```

---

## lib.mkDefault vs lib.mkForce vs lib.mkIf

| Function | Priority | When to use |
|---|---|---|
| `lib.mkDefault x` | Low (1000) | Bundle sets a value; host can override without `mkForce` |
| plain assignment `x` | Normal (100) | Host sets a value; wins over `mkDefault` |
| `lib.mkForce x` | High (50) | Override everything; used in server bundle to force-disable Hyprland |
| `lib.mkIf condition x` | Conditional | Apply config only when condition is true; same priority as surrounding context |

**Pattern from laptop.nix**:
```nix
# Bundle file:
myModules.services.tlp.enable = lib.mkDefault true;   # on by default, host can turn off

# Host file (wins without mkForce):
myModules.services.tlp.enable = false;                 # override bundle

# Never needed but possible (overrides everything):
myModules.services.tlp.enable = lib.mkForce false;
```

**mkIf inside mkIf** (from laptop.nix):
```nix
services.thermald.enable = lib.mkIf (cfg.enableThermald && hasIntelCPU) (lib.mkDefault true);
```

---

## lib.mkMerge

Merges multiple config attribute sets. Used when a module's config block has multiple conditional sections:

```nix
config = lib.mkIf cfg.enable (lib.mkMerge [
  {
    services.foo.enable = true;
  }
  (lib.mkIf cfg.enableExtra {
    services.foo.extraOption = true;
  })
]);
```

Used in `nixosModules/services/tlp.nix`.

---

## How specialArgs and extraSpecialArgs work

**`specialArgs`** in `flake.nix`:
```nix
nixpkgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules = [ ... ];
};
```
This injects `inputs` into every NixOS module's argument list. Any module declaring `{ ..., inputs, ... }` receives it.

**`extraSpecialArgs`** in `configuration.nix`:
```nix
home-manager.extraSpecialArgs = { inherit inputs; };
```
This injects `inputs` into every Home Manager module's argument list, since HM modules are a separate module system.

**Accessing inputs in modules**:
```nix
{ config, lib, pkgs, inputs, ... }:  # declare inputs in the args
{
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
}
```

---

## Import patterns

### Importing a directory

```nix
imports = [ ./services ];
# Nix looks for ./services/default.nix
```

### Importing all modules via default.nix

`nixosModules/services/default.nix`:
```nix
{ imports = [ ./bolt.nix ./brightnessctl.nix ... ]; }
```

`nixosModules/default.nix` imports `./services` which triggers the above.

### NixOS import deduplication

NixOS deduplicates imports — importing the same module twice has no effect. This is why `laptop.nix` can re-import `./services` even though `default.nix` already imported it.

---

## Hardware detection pattern

```nix
let
  hasIntelCPU = config.hardware.cpu.intel.updateMicrocode or false;
  hasAMDCPU   = config.hardware.cpu.amd.updateMicrocode or false;
in
```

Used in `nixosModules/laptop.nix`. The `or false` guard handles the case where the option is undefined.

Conditional packages:
```nix
environment.systemPackages = with pkgs; [
  basePackage
] ++ lib.optionals hasAMDCPU [
  ryzenadj
] ++ lib.optionals hasIntelCPU [
  powertop
];
```

---

## Accessing the primary user in NixOS modules

```nix
let user = config.userGlobals.username; in
{
  users.users.${user}.extraGroups = [ "somegroup" ];
  services.something.user = user;
}
```

`userGlobals.username` is defined in `nixosModules/default.nix`. Every host must set it.

---

## lib.optionalAttrs and lib.optionals

```nix
# For attribute sets (lib.optionalAttrs):
matchBlocks =
  cfg.matchBlocks
  // lib.optionalAttrs cfg.enableControlMaster {
    "*" = { controlMaster = "auto"; };
  };

# For lists (lib.optionals):
packages = baseList ++ lib.optionals condition [ extraPkg ];
```

---

## Referencing flake inputs for packages

```nix
# From nixosModules/programs/agenix.nix:
inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default

# From nixosModules/programs/hyprland.nix:
inputs.hyprland.packages."${pkgs.stdenv.hostPlatform.system}".hyprland
```

`pkgs.stdenv.hostPlatform.system` gives the current system string (e.g. `"x86_64-linux"`).

---

## lib.mkForce usage in server bundle

```nix
# server.nix — force-disable GUI things for servers:
services.xserver.enable = lib.mkForce false;
programs.hyprland.enable = lib.mkForce false;
```

Use `mkForce` sparingly. It overrides any other assignment including `mkDefault`. Only appropriate for mutual exclusions (a server should never run Hyprland regardless of what other modules say).

---

## Repo-specific idioms

- `cfg = config.myModules.<category>.<name>` is always the `let` binding for the current module's options
- Bundle modules always use `lib.mkDefault` (not plain assignment) when enabling child modules
- Hosts use plain assignment (or explicit `true`) when they need a specific value regardless of bundle defaults
- `lib.mkIf` at the top of `config = lib.mkIf cfg.enable { ... }` is the universal guard pattern
- `inputs.rose-pine-hyprcursor.packages.${...}.default` is the cursor package referenced in stylix config
