# Skill: Provisioning a new host

## Prerequisites

- NixOS installed on target machine (or in a VM)
- This flake cloned to the target machine
- Hardware scan completed: `sudo nixos-generate-config --root /mnt` (or `/` if already booted)

---

## Step 1: Create the host directory

```
hosts/<HOSTNAME>/
  configuration.nix
  hardware-configuration.nix    ← copy from /etc/nixos/ or /mnt/etc/nixos/
  home.nix
```

Use UPPERCASE for the hostname (convention: BISHOP).

---

## Step 2: Write configuration.nix

Minimal template based on `hosts/BISHOP/configuration.nix`:

```nix
{ config, pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.xremap-flake.nixosModules.default   # if using xremap
    ../../nixosModules
    ../../users/<username>
  ];

  networking.hostName = "<HOSTNAME>";

  userGlobals.username = "<username>";

  myModules.<bundle>.enable = true;   # laptop / desktop / server

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."<username>" = import ./home.nix;
  };

  myModules.shared.stylix = {
    enable = true;
    image = ../../assets/wall.jpeg;
  };

  system.stateVersion = "<nixos-version>";  # e.g. "25.05" — set once, never change
}
```

**Notes**:
- `../../nixosModules` pulls in all modules and the default config
- `../../users/<username>` pulls in the user's NixOS-level config
- `userGlobals.username` drives user account creation and group memberships
- home-manager is already in `flake.nix` modules, but `extraSpecialArgs` must be set per-host

---

## Step 3: Write home.nix

Minimal template based on `hosts/BISHOP/home.nix`:

```nix
{ config, pkgs, inputs, lib, ... }:
{
  imports = [
    ../../homeManagerModules
    ../../users/<username>/home.nix
    inputs.nixvim.homeModules.nixvim
    inputs.ags.homeManagerModules.default
    inputs.walker.homeManagerModules.walker
  ];

  myHomeModules.<bundle>.enable = true;   # laptop

  # Override wallpaper for this host
  myHomeModules.guiPrograms.stylix.image = ../../assets/wall.jpeg;

  # Host-specific display profiles (if using kanshi)
  services.kanshi.settings = [
    {
      profile.name = "undocked";
      profile.outputs = [
        { criteria = "eDP-1"; scale = 1.0; status = "enable"; }
      ];
    }
  ];

  home.stateVersion = "<hm-version>";  # e.g. "24.11" — set once, never change
}
```

**Notes**:
- `../../homeManagerModules` imports all HM modules
- `../../users/<username>/home.nix` brings in user identity (git, SSH, etc.)
- nixvim, ags, and walker are flake-level HM modules that must be imported explicitly here

---

## Step 4: Add the host to flake.nix

In `flake.nix`, inside `nixosConfigurations`:

```nix
<HOSTNAME> = nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules = [
    ./hosts/<HOSTNAME>/configuration.nix
    agenix.nixosModules.default
    home-manager.nixosModules.default
    stylix.nixosModules.stylix
    {
      home-manager.sharedModules = [ agenix.homeManagerModules.default ];
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      nixpkgs.overlays = [
        yazi.overlays.default
      ];
    }
  ];
};
```

Copy the BISHOP block exactly and change `BISHOP` → `<HOSTNAME>` and the `configuration.nix` path.

---

## Step 5: Ensure the user exists

If this is a new username:
1. Create `users/<username>/default.nix` (NixOS side — can be empty, see `users/ginner/default.nix`)
2. Create `users/<username>/home.nix` (HM side — git config, SSH, etc.)
3. Add `./users/<username>` to `users/default.nix` imports

---

## Step 6: Build and switch

On the target machine, from this flake directory:

```bash
sudo nixos-rebuild switch --flake .#<HOSTNAME>
```

After first boot, set the user password:
```bash
passwd <username>
```

---

## Step 7: Post-build steps (if applicable)

- **rbw** (Bitwarden): `rbw config set email <email>`
- **Thunderbolt dock**: `boltctl list` → `boltctl enroll <device-id>`
- **Email** (neomutt): If `email-config.nix` is not present in the repo, create it:
  ```bash
  cp users/<username>/email-config.template.nix ~/.config/nixos-secrets/email-config.nix
  $EDITOR ~/.config/nixos-secrets/email-config.nix
  ```
  Then symlink into place so Nix can see it:
  ```bash
  ln -s ~/.config/nixos-secrets/email-config.nix users/<username>/email-config.nix
  git add -N users/<username>/email-config.nix  # track without committing content
  ```
- **OpenCode**: Start and run `/connect` to connect to the AI API
