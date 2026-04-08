# LT·HL OS

## Host-specific configuration
`./hosts/<HOSTNAME/[configuration.nix,home.nix]`
Intended for at per-host (each computer) configuration. This should reflect the intended use of the host.

## User-specific configuration
`./users/<username>/[configuration.nix,home.nix]`
Intended for per-user configuration.

## Laptop module
Dock fix: `boltctl list` -> `boltctl enroll <device-id>`

## Default module
The user is set, you need to set a password for the user with `passwd <username>`(_I'm not sure how this works in my setup..._).

## TODO
- [ ] Neomutt
- [ ] Calcurse
- [ ] direnv
- [ ] LaTeX
- [ ] [cheat](https://github.com/cheat/cheat)/[cheat.sh](https://github.com/chubin/cheat.sh)/[navi](https://github.com/denisidoro/navi)?
- [ ] Combine desktop/Laptop - The only differences are tlp, I think. Maybe it could just be handled as a 'small' toggle...
- [ ] Add host-options: VM, wsl,
- [ ] preconfigure pinentry for rbw (`pinentry-tty`)

## Secrets (sops-nix)

All secrets are managed by [sops-nix](https://github.com/Mic92/sops-nix) and stored encrypted in `secrets/`. Encrypted files are safe to commit — plaintext never enters the Nix store or version control.

Key configuration lives in `.sops.yaml` at the repo root.

### Fresh machine setup (one-time manual step)

This is the **only** manual step required before `nixos-rebuild switch` will work:

**Option A — bare age key (recommended):**
```bash
nix-shell -p age --run 'mkdir -p ~/.config/sops/age && age-keygen -o ~/.config/sops/age/keys.txt'
# The public key is printed to stdout — add it to .sops.yaml as &user_ginner
```

**Option B — derive from an existing passphrase-free SSH ed25519 key:**
```bash
nix-shell -p ssh-to-age --run 'mkdir -p ~/.config/sops/age && ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt'
# Note: the SSH key must have no passphrase for this to work
```

After generating the key, restore or rebuild `secrets/email.yaml`:
```bash
nix-shell -p sops --run 'sops secrets/email.yaml'
```

The host SSH key (`/etc/ssh/ssh_host_ed25519_key`) is used for NixOS-level decryption and is generated automatically on first boot — no setup needed there.

### Adding `.sops.yaml` keys for a new machine

1. Get the host age pubkey:
   ```bash
   nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
   ```
2. Add it to `.sops.yaml` and re-encrypt all secret files:
   ```bash
   nix-shell -p sops --run 'sops updatekeys secrets/email.yaml'
   ```

### Secret file structure (`secrets/email.yaml`)

Contains 6 keys: `work-address`, `work-realname`, `work-rbw-key`, `private-address`, `private-realname`, `private-rbw-key`.

These are injected into mbsync, msmtp, and neomutt config files at activation time via sops templates. No plaintext email addresses or passwords ever enter the Nix store.

## Styling (Stylix)

Theming is managed by [Stylix](https://stylix.danth.me) via the NixOS module (`stylix.nixosModules.stylix` in `flake.nix`). It applies a single theme to both system-level and Home Manager targets automatically.

**Canonical theme config**: `nixosModules/shared/stylix.nix` (enabled per-host via `myModules.shared.stylix`).

| Option | Where to change |
|---|---|
| Color scheme | `myModules.shared.stylix.base16Scheme` in host `configuration.nix` |
| Wallpaper (system) | `myModules.shared.stylix.image` in host `configuration.nix` |
| Wallpaper (user override) | `stylix.image` in host `home.nix` |
| Fonts | `myModules.shared.stylix.fonts.*` in host `configuration.nix` |
| Cursor | `myModules.shared.stylix.cursor.*` in host `configuration.nix` |
| Disable theming for a program | `stylix.targets.<name>.enable = false` in host `home.nix` |

Schemes are YAML files from `pkgs.base16-schemes` (e.g. `catppuccin-frappe.yaml`, `gruvbox-dark-hard.yaml`). Browse available schemes with `ls $(nix-build '<nixpkgs>' -A base16-schemes)/share/themes/`.

## Post build

### rbw
_Bitwarden commandline client_

After build, `rbw` needs its config written. If using the `cliPrograms.rbw` HM module with a sops secret, this is automatic. If installed as a raw package (current setup), run:
```bash
rbw config set email <user-email>
```

### OpenCode
Start opencode and do `/connect` and connect to the API of choice.
