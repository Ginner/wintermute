# AGENTS.md — users/

Each subdirectory is one user. The directory name is the username.

## Declarativeness policy

Manual post-install steps must be minimised. Any step that cannot be automated must be documented in `README.md`. The goal is: clone repo → restore your age private key → `nixos-rebuild switch` → done.

**PII and secrets are distinct:**
- **Secrets** (passwords, API keys): never in version control or Nix store → sops templates only
- **PII** (email addresses, real names): never in version control, Nix store is fine → also via sops templates since there is no eval-time injection mechanism that avoids committed files

**User-facing files only.** A user of this config should only need to edit:
- `hosts/<hostname>/configuration.nix`
- `hosts/<hostname>/home.nix`
- `users/<username>/home.nix`

No changes to `nixosModules/` or `homeManagerModules/` should be required for a new host or user.

## Directory structure per user

```
users/<username>/
  default.nix       ← NixOS-level user config (imported by hosts via ../../users/<username>)
  home.nix          ← HM user config (imported by hosts/<HOSTNAME>/home.nix)
  .secrets/secrets.nix  ← legacy agenix public key file, kept for key reference
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
- Sops age key path and `defaultSopsFile` pointer
- Email account definitions (`myHomeModules.services.email.accounts.*`) — IMAP/SMTP hosts and macro keys only; no addresses or passwords
- Opt-in to optional modules (`myHomeModules.tuiPrograms.neomutt.enable`, etc.)
- Additional packages specific to this user (`home.packages`)
- Imported into the host via `imports = [ ../../users/<username>/home.nix ]` in `hosts/<HOSTNAME>/home.nix`
- Module options set here take priority over bundle `mkDefault` values but yield to host-level `mkForce`

**`secrets/email.yaml`** (repo root, encrypted):
- sops-encrypted YAML with keys: `<accountname>-address`, `<accountname>-realname`, `<accountname>-rbw-key` per account
- Safe to commit — plaintext never leaves the machine
- Referenced from `users/<username>/home.nix` via `sops.defaultSopsFile = ../../secrets/email.yaml`

## User configs are additive

User configs extend what the host/bundle already provides — they never disable things the bundle enables (do not use `lib.mkForce false` without good reason). They override identity-specific values (git name, SSH keys) and opt into optional modules that are `mkDefault false` in the bundle.

## Existing users

| User | Notes |
|---|---|
| ginner | Primary user; email via neomutt (email module + sops), contacts via khard, opencode enabled; rbw installed as raw package |

## Known issues

No outstanding known issues.

## Adding a new user

See `skills/new-user.md` for step-by-step instructions.
