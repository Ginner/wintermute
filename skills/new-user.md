# Skill: Adding a new user

## When to use this

- Adding a second user to an existing host
- Adding a new user identity to be shared across hosts

---

## Step 1: Create the user directory

```
users/<username>/
  default.nix         ← NixOS system-level user config
  home.nix            ← HM user identity config
```

### `users/<username>/default.nix`

Can be empty initially (see `users/ginner/default.nix`):

```nix
{ config, lib, pkgs, ... }:
{
  # User-specific NixOS configuration
  # Add: custom systemd services, udev rules, user-specific system packages
}
```

### `users/<username>/home.nix`

Contains user identity (derived from `users/ginner/home.nix`):

```nix
{ config, pkgs, inputs, lib, ... }:
{
  # Override the hardcoded username/homedir from homeManagerModules/default.nix
  home.username = lib.mkForce "<username>";
  home.homeDirectory = lib.mkForce "/home/<username>";

  # Git identity
  programs.git.settings = {
    user = {
      name = "Full Name";
      email = "email@example.com";
    };
  };

  # SSH match blocks (user-specific hosts/keys)
  myHomeModules.cliPrograms.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  # Opt into optional modules that are mkDefault false in the bundle
  myHomeModules.tuiPrograms.neomutt.enable = true;

  # User-specific packages
  home.packages = with pkgs; [ ];
}
```

**Important**: Override `home.username` and `home.homeDirectory` with `lib.mkForce` because `homeManagerModules/default.nix` hardcodes them as `lib.mkDefault "ginner"`.

---

## Step 2: Register the user in users/default.nix

`users/default.nix` imports all user sub-directories:

```nix
{
  imports = [
    ./ginner
    ./<username>     # add this line
  ];
}
```

---

## Step 3: Wire the user into the host

In `hosts/<HOSTNAME>/configuration.nix`:

```nix
imports = [
  ./hardware-configuration.nix
  ../../nixosModules
  ../../users/<username>     # NixOS-side user config
];

userGlobals.username = "<username>";

home-manager.users."<username>" = import ./home.nix;
```

In `hosts/<HOSTNAME>/home.nix`:

```nix
imports = [
  ../../homeManagerModules
  ../../users/<username>/home.nix    # HM-side user config
  inputs.nixvim.homeModules.nixvim
  inputs.ags.homeManagerModules.default
  inputs.walker.homeManagerModules.walker
];
```

---

## Step 4: Set a password after first build

```bash
sudo nixos-rebuild switch --flake .#<HOSTNAME>
passwd <username>
```

---

## Notes on multi-user hosts

This flake currently assumes a single primary user per host (`userGlobals.username`). The `nixosModules/default.nix` creates only one user account. For a second user on the same host:

1. The second user's NixOS account must be created manually or via direct `users.users.*` config in the host's `configuration.nix`
2. The second user's HM config must be added to `home-manager.users."<seconduser>" = import ...`
3. The `userGlobals.username` option only covers the primary user for service group memberships etc.

This multi-user case is not fully implemented; `userGlobals` would need to be extended or the second user managed more manually.
