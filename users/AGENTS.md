# AGENTS.md — users/

Each subdirectory is one user. The directory name is the username.

## Declarativeness policy

Manual post-install steps must be minimised. Any step that cannot be automated must be documented in `README.md`. The goal is: clone repo → restore your age private key → `nixos-rebuild switch` → done. **PII must never appear in version control** — not even in git-ignored files within the repo. All secrets belong in `secrets/` as sops-encrypted YAML, committed safely to git.

## Directory structure per user

```
users/<username>/
  default.nix       ← NixOS-level user config (imported by hosts via ../../users/<username>)
  home.nix          ← HM user config (imported by hosts/<HOSTNAME>/home.nix)
  .secrets/secrets.nix  ← sops public key declarations for user secrets (optional; legacy agenix file, kept for key reference)
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
- sops secret declarations and config-file templates (for email accounts)
- Additional packages specific to this user (`home.packages`)
- Imported into the host via `imports = [ ../../users/<username>/home.nix ]` in `hosts/<HOSTNAME>/home.nix`
- Module options set here take priority over bundle `mkDefault` values but yield to host-level `mkForce`

**`secrets/email.yaml`** (repo root, encrypted):
- sops-encrypted YAML with 6 keys: `work-address`, `work-realname`, `work-rbw-key`, `private-address`, `private-realname`, `private-rbw-key`
- Safe to commit — plaintext never leaves the machine
- Referenced from `users/ginner/home.nix` via `sops.defaultSopsFile = ../../secrets/email.yaml`

## User configs are additive

User configs extend what the host/bundle already provides — they never disable things the bundle enables (do not use `lib.mkForce false` without good reason). They override identity-specific values (git name, SSH keys, email) and opt into optional modules that are `mkDefault false` in the bundle.

## Existing users

| User | Notes |
|---|---|
| ginner | Primary user; email via neomutt (sops templates), contacts via khard, opencode enabled; rbw installed as raw package |

## Known issues

No outstanding known issues.

## Adding a new user

See `skills/new-user.md` for step-by-step instructions.
