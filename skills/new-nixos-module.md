# Skill: Adding a new NixOS module

This covers adding a module to `nixosModules/services/` or `nixosModules/programs/`.

## Step 1: Decide where it goes

- **services/**: Background daemons, kernel features, hardware management (e.g. pipewire, tailscale, greetd)
- **programs/**: System-level CLI tools or programs requiring system enablement (e.g. hyprland, zsh, agenix)

When in doubt: does it run as a systemd service or require a persistent process? → services/. Is it a CLI tool or program that NixOS enables system-wide? → programs/.

---

## Step 2: Create the module file

Example: `nixosModules/services/myservice.nix`

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.services.myservice;
  user = config.userGlobals.username;  # use this if the service needs the primary user
in
{
  options.myModules.services.myservice = {
    enable = lib.mkEnableOption "My service description";

    # Add configurable options with sensible defaults:
    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port for myservice to listen on";
    };
  };

  config = lib.mkIf cfg.enable {
    services.myservice = {
      enable = true;
      # use cfg.port etc.
    };

    # If the service needs the user in a group:
    users.users.${user}.extraGroups = [ "myservice-group" ];

    # Packages needed at system level:
    environment.systemPackages = [ pkgs.myservice-client ];
  };
}
```

**Rules**:
- Option path: `myModules.services.<name>` or `myModules.programs.<name>`
- Always gate config behind `lib.mkIf cfg.enable`
- Default for `enable` is `false` (mkEnableOption gives this automatically)
- Never hardcode usernames — use `config.userGlobals.username`
- Use `lib.mkDefault` when setting values that hosts should be able to override
- If using flake inputs, add `inputs` to the argument list: `{ config, lib, pkgs, inputs, ... }`

---

## Step 3: Register it in the sub-directory's default.nix

For a new service, add it to `nixosModules/services/default.nix`:

```nix
{
  imports = [
    # ... existing imports ...
    ./myservice.nix
  ];
}
```

For a new program, add it to `nixosModules/programs/default.nix`.

The top-level `nixosModules/default.nix` already imports `./services` and `./programs`, so no change there.

---

## Step 4: Optionally add to a bundle

If the module should be on by default for a bundle (laptop/desktop/server), add to the relevant bundle file:

In `nixosModules/laptop.nix` (inside `config = lib.mkIf cfg.enable { ... }`):

```nix
myModules.services.myservice.enable = lib.mkDefault true;
```

Using `lib.mkDefault` means hosts can still set `myModules.services.myservice.enable = false` to override.

---

## Step 5: Test

```bash
# Check syntax
nix-instantiate --parse nixosModules/services/myservice.nix

# Check if it evaluates in context
nix eval .#nixosConfigurations.BISHOP.config.myModules.services.myservice.enable

# Full build test
sudo nixos-rebuild test --flake .#BISHOP
```

---

## Reference: modules with multiple config sections

When you need multiple distinct configuration blocks, use `lib.mkMerge`:

```nix
config = lib.mkIf cfg.enable (lib.mkMerge [
  {
    services.myservice.enable = true;
  }
  (lib.mkIf cfg.enableExtra {
    services.myservice.extraFeature = true;
  })
]);
```

This pattern is used in `nixosModules/services/tlp.nix`.
