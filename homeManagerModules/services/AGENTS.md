# AGENTS.md — homeManagerModules/services/

User-level services: background processes, portal configuration, and account-level infrastructure that supports other programs.

## What belongs here

- XDG portal and MIME configuration
- Email infrastructure (mbsync, msmtp, notmuch, per-account sops templates)
- Display management daemons (kanshi)
- Future: calendar/contact sync daemons, systemd user timers

## Current modules

| File | Option path | Description |
|---|---|---|
| email/ | `myHomeModules.services.email` | Full email toolchain — generic multi-account, sops-driven |
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

**email/default.nix**: Generic multi-account email module. Exposes `myHomeModules.services.email.accounts` as an attrset of account submodules. Each account declares IMAP/SMTP hosts, an account-switching macro key, and optional sops secret key name overrides. The module generates all config files via sops templates at activation time:
- `~/.config/isyncrc` — mbsync config (one stanza per account; includes `PostSyncHook notmuch new`)
- `~/.config/msmtp/config` — msmtp config (one stanza per account)
- `~/.config/neomutt/<name>` — per-account neomutt identity file
- `~/.config/notmuch/default/config` — notmuch config (primary account address via sops placeholder)

Does **not** use HM's `programs.notmuch.user` to avoid the primaryEmail assertion — installs notmuch via `home.packages` and writes the config via sops template instead. Does **not** use `accounts.email.accounts`. PII (addresses, real names) and secrets (password commands) both come from the sops-encrypted `secrets/email.yaml` file.

Default sops key names for an account named `foo`: `foo-address`, `foo-realname`, `foo-password`. Override with `addressSecret`, `realnameSecret`, `passwordSecret` per account if needed.

## Secret vs PII policy (enforced here)

- **Secrets** (password commands): never in version control or Nix store → sops template injection only
- **PII** (email addresses, real names): never in version control, Nix store is acceptable → also via sops templates since there is no eval-time injection mechanism that avoids committed files

## Relationship to neomutt

`homeManagerModules/tuiPrograms/neomutt.nix` reads `config.myHomeModules.services.email.accounts` to dynamically generate account-switching macros (i<macroKey>) and to source the primary account file at startup. The email module writes those per-account files; neomutt just sources them.

Expected setup in `users/<username>/home.nix`:
```nix
sops.defaultSopsFile = ../../secrets/email.yaml;
myHomeModules.services.email = {
  enable = true;
  accounts.work = {
    primary  = true;
    imapHost = "imap.example.com";
    smtpHost = "smtp.example.com";
    macroKey = "1";
  };
};
myHomeModules.tuiPrograms.neomutt.enable = true;
```

## Adding a new service module

See `skills/new-home-module.md`.
