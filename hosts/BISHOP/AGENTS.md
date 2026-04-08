# AGENTS.md — hosts/BISHOP/

## Hardware

- **CPU**: AMD (confirmed by `hardware.cpu.amd.updateMicrocode` in hardware-configuration.nix; `kvm-amd` kernel module)
- **Storage**: NVMe SSD
- **Boot**: systemd-boot, EFI
- **Thunderbolt**: present (`thunderbolt` in initrd kernel modules; `bolt` service enabled via laptop bundle)
- **Input devices** (observed in hyprland config):
  - Touchpad: `elan06c2:00-04f3:3195` (disabled in Hyprland config — TrackPoint preferred)
  - TrackPoint: `tpps/2-synaptics-trackpoint` (sensitivity 0.15, flat accel, natural_scroll off)
- **Filesystem**: ext4 on `/`, vfat on `/boot`

This appears to be a ThinkPad-class laptop based on the touchpad/TrackPoint device names.

## Bundle

Uses `myModules.laptop.enable = true` (NixOS) and `myHomeModules.laptop.enable = true` (HM).

Additional services enabled at host level:
- `myModules.services.tailscale.enable = true` (laptop bundle sets this to `mkDefault false`)

HM-level overrides set directly in `home.nix`:
- `stylix.image` — wallpaper path (NixOS module propagates the rest of the theme via autoImport)
- `stylix.targets.waybar.enable = false` — waybar is themed manually, not by Stylix

## stateVersion

- NixOS: `"24.11"` (`configuration.nix`)
- Home Manager: `"22.11"` (`home.nix`) — do not change either value

## Display / Monitor configuration

Kanshi profiles defined in `home.nix`:

| Profile | Outputs |
|---|---|
| `undocked` | eDP-1 @ scale 1.2, brightness 40% |
| `office` | eDP-1 (1920×? @ 1.0) + Dell U2717D (4K) + Dell U2417H (portrait, 270°) |

The Dell U2717D serial: T4F1X87A735S; Dell U2417H serial: 5K9YD734A3ES. These are used as `criteria` in the kanshi config.

## Secrets

- `hosts/BISHOP/.secrets/secrets.nix`: Public keys declared (host key `ssh-ed25519`). Currently no active secret file declarations — the body is empty.
- User secrets: `users/ginner/.secrets/secrets.nix`

## AMD-specific behaviour

The laptop bundle detects AMD CPU via `config.hardware.cpu.amd.updateMicrocode` and installs `ryzenadj`. Intel-only `thermald` and `powertop` are skipped.

## Known quirks

- The elan touchpad is explicitly disabled in Hyprland (`"device[elan06c2:00-04f3:3195-touchpad]".enabled = false`)
- Hyprland config has a hardcoded TODO comment noting that device config "has to be handled in host configurations" — this is a known issue; device-specific Hyprland settings are currently in the shared `homeManagerModules/guiPrograms/hyprland.nix`
- `configuration.nix` imports `inputs.xremap-flake.nixosModules.default` directly (not via nixosModules system)

## Quirks for future maintenance

- If kanshi stops activating on login, check `systemdTarget = "hyprland-session.target"` in the kanshi module
- `bolt` service manages Thunderbolt device authorisation. After connecting a new Thunderbolt device: `boltctl list` → `boltctl enroll <device-id>`
- rbw (Bitwarden CLI) requires post-build setup: `rbw config set email <email>`
