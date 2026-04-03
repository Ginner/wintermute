# AGENTS.md — users/

Each subdirectory is one user. The directory name is the username.

## Directory structure per user

```
users/<username>/
  default.nix       ← NixOS-level user config (imported by hosts via ../../users/<username>)
  home.nix          ← HM user config (imported by hosts/<HOSTNAME>/home.nix)
  .secrets/secrets.nix  ← agenix public key declarations for user secrets (optional)
  email-config.template.nix  ← Template for git-ignored email-config.nix (optional)
```

`users/default.nix` is a thin shim that just `imports = [ ./ginner ]`.

## Role of each file

**`default.nix`** (NixOS side):
- User-level NixOS system configuration
- Currently empty for `ginner` — provides structure for future additions
- Intended for: custom systemd services, udev rules, user-specific system packages
- Imported into the host via `imports = [ ../../users/<username> ]` in `hosts/<HOSTNAME>/configuration.nix`

**`home.nix`** (HM side):
- User identity: git name/email, SSH match blocks
- Opt-in to optional modules (e.g., `myHomeModules.tuiPrograms.neomutt.enable = true`)
- Additional packages specific to this user (`home.packages`)
- Imported into the host via `imports = [ ../../users/<username>/home.nix ]` in `hosts/<HOSTNAME>/home.nix`
- Module options set here take priority over bundle `mkDefault` values but yield to host-level `mkForce`

**`email-config.nix`** (git-ignored):
- Not in the repository; created manually at `users/ginner/email-config.nix` (or at `~/.config/nixos-secrets/email-config.nix` per README)
- Template provided at `users/ginner/email-config.template.nix`
- Contains: email address, realName, passwordCommand for work and private accounts
- Required if `myHomeModules.services.email-accounts.enable = true`

## User configs are additive

User configs extend what the host/bundle already provides — they never disable things the bundle enables (do not use `lib.mkForce false` without good reason). They override identity-specific values (git name, SSH keys, email) and opt into optional modules that are `mkDefault false` in the bundle.

## Existing users

| User | Notes |
|---|---|
| ginner | Primary user; email via neomutt, contacts via khard, opencode enabled; rbw installed as raw package (module requires agenix secret not yet wired) |

## Known issues

No outstanding known issues.

## Adding a new user

See `skills/new-user.md` for step-by-step instructions.
