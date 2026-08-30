# ApexOS System Instructions

These instructions apply to systems configured with the reusable ApexOS layer.
More specific user, host, and project instructions take precedence.

## NixOS Context

- The system is NixOS.
- Prefer declarative configuration over imperative or manual setup.
- Do not assume packages, services, shells, fonts, desktop settings, or user programs should be installed manually.
- Prefer editing NixOS, Home Manager, flake, or project devshell configuration when changing persistent system behavior.
- Avoid suggesting `apt`, `dnf`, `pacman`, `brew`, or global language package installs unless explicitly working inside a non-Nix environment.
- If a tool is missing, first consider whether it belongs in Nix configuration, `nix shell`, `nix run`, or a project flake or devshell.
- Assume the host is NixOS before running or suggesting commands.
- Never invoke `python`, `python3`, `pip`, or `pip3` directly.
- Use the project's flake or development shell when available.
- Otherwise run Python through Nix, such as `nix shell nixpkgs#python3 -c python ...`.
- Inspect the repository and its Nix configuration before attempting tool installation or environment setup.
