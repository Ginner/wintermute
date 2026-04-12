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
- [ ] agenix
- [ ] Neomutt
- [ ] Calcurse
- [ ] direnv
- [ ] LaTeX
- [ ] [cheat](https://github.com/cheat/cheat)/[cheat.sh](https://github.com/chubin/cheat.sh)/[navi](https://github.com/denisidoro/navi)?
- [ ] Combine desktop/Laptop - The only differences are tlp, I think. Maybe it could just be handled as a 'small' toggle...
- [ ] Add host-options: VM, wsl, 
- [ ] preconfigure pinentry for rbw (`pinentry-tty`)

## Pre-build
### agenix

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

After build, `rbw` is configured using the following commands:
`rbw config set email <user-email>`

### OpenCode
Start opencode and do `/connect` and connect to the API of choice. 

## Email (neomutt)
`agenix` secrets not available at build time + files not tracked by `git` not 'seen' by Nix → Manual steps:
```
mkdir -p ~/.config/nixos-secrets
cp users/ginner/email-config.template.nix ~/.config/nixos-secrets/email-config.nix
nvim ~/.config/nixos-secrets/email-config.nix
```

## Adding a Firefox extension

Firefox extensions are managed declaratively via the `ExtensionSettings` policy in
`homeManagerModules/guiPrograms/firefox.nix`. The policy engine matches entries by
**extension GUID** — not the extension's name, slug, or support email.

### Finding the correct GUID

Use the AMO (addons.mozilla.org) REST API. The slug is the last segment of the
extension's AMO page URL.

```bash
curl -s "https://addons.mozilla.org/api/v5/addons/addon/<slug>/" | jq -r '.guid'
```

Examples:

```bash
# Dark Reader  →  https://addons.mozilla.org/en-US/firefox/addon/darkreader/
curl -s "https://addons.mozilla.org/api/v5/addons/addon/darkreader/" | jq -r '.guid'
# addon@darkreader.org

# Bitwarden  →  https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/
curl -s "https://addons.mozilla.org/api/v5/addons/addon/bitwarden-password-manager/" | jq -r '.guid'
# {446900e4-71c2-419f-a6a7-df9c091e268b}
```

> **Common mistake**: the AMO page also shows a support email (e.g. `darkreaderapp@gmail.com`).
> This looks like an extension ID but is not — always use `jq -r '.guid'`, never `.support_email`.

### Adding the entry

In `homeManagerModules/guiPrograms/firefox.nix`, inside `ExtensionSettings`:

```nix
# My Extension:
"<guid-from-above>" = {
  install_url = "https://addons.mozilla.org/firefox/downloads/latest/<slug>/latest.xpi";
  installation_mode = "normal_installed"; # or "force_installed" to prevent disabling
  default_area = "menupanel";             # or "navbar" to pin in the address bar toolbar
};
```

`installation_mode` options:
- `normal_installed` — installed by policy, user can disable it
- `force_installed` — installed and locked on; user cannot disable it
- `blocked` — extension is blocked from being installed (used by the `"*"` catch-all)

Rebuild to apply:

```bash
sudo nixos-rebuild switch --flake .#BISHOP
