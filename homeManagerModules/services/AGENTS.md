# AGENTS.md — homeManagerModules/services/

User-level services: background processes, portal configuration, and account-level infrastructure that supports other programs.

## What belongs here

- XDG portal and MIME configuration
- Email infrastructure (mbsync, msmtp, notmuch) — account definitions live in user configs
- Display management daemons (kanshi)
- Future: calendar/contact sync daemons, systemd user timers

## Current modules

| File | Option path | Description |
|---|---|---|
| email-accounts.nix | `myHomeModules.services.email-accounts` | Email toolchain (mbsync, msmtp, notmuch) |
| kanshi.nix | `myHomeModules.services.kanshi` | Wayland display output profiles (hotplug) |
| xdg.nix | `myHomeModules.services.xdg` | XDG portals, user dirs, MIME defaults, desktop entries |

## Module notes

**kanshi.nix**: Exposes only `enable`. Targets `hyprland-session.target` so it starts with Hyprland. Host-specific display profiles (`services.kanshi.settings`) are set directly in `hosts/<HOSTNAME>/home.nix` — this is the correct place for per-host display configuration. The laptop bundle enables this with `mkDefault true`.

**xdg.nix**: Enables `xdg-desktop-portal-hyprland` and `xdg-desktop-portal-gtk`. Configures XDG user dirs — notably `downloads` maps to `~/INBOX` (not the standard `~/Downloads`). Sets MIME defaults:
- `text/*` → nvim (via `nvim.desktop` entry, launched in kitty)
- `application/pdf` → zathura
- `image/*` → swayimg
- `video/*` → mpv

Also creates a `nvim.desktop` entry so nvim appears in app launchers for text files.

**email-accounts.nix**: Sets `accounts.email.maildirBasePath` to `$XDG_DATA_HOME/mail`. Enables `mbsync`, `msmtp`, and `notmuch` globally. Actual account definitions (`accounts.email.accounts.*`) are set in user configs (`users/ginner/home.nix`), not here. Notmuch tags new mail as `unread inbox`; excludes `deleted` and `spam` from searches.

## Relationship to neomutt

`homeManagerModules/tuiPrograms/neomutt.nix` depends on email accounts being configured. The expected setup is:
1. `myHomeModules.services.email-accounts.enable = true` — provides the toolchain
2. `accounts.email.accounts.*` defined in the user's `home.nix` — provides account credentials/config
3. `myHomeModules.tuiPrograms.neomutt.enable = true` — provides the UI

## Adding a new service module

See `skills/new-home-module.md`.
