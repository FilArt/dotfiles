# AGENTS.md

## Purpose
- This repository contains NixOS and Home Manager configuration for the `art` user.
- Prefer small, targeted edits that preserve the existing module split instead of adding more logic to top-level entrypoints.

## Repository Map
- `flake.nix`: main entrypoint. Defines two NixOS systems:
  - `nixos`: the primary machine, composed from `configuration.nix` plus Home Manager via `home.nix`
  - `archie`: a separate host under `./hosts/archie`
- `configuration.nix`: main NixOS module for the primary `nixos` system
- `home.nix`: main Home Manager module for `art`
- `home/default.nix`: Home Manager aggregator
- `home/programs/*.nix`: Home Manager `programs.*` modules
- `home/services/*.nix`: Home Manager user-service modules
- `home/desktop/*.nix`: desktop/session UI modules
- `programs/*.nix`: NixOS-level `programs.*` modules
- `services.nix`: NixOS-level `services.*` configuration
- `options/*.nix`: split NixOS options by domain
- `hosts/archie/default.nix`: standalone host definition for `archie`

## How To Choose The Right File
- If the change affects user applications, shell config, editor config, terminal config, or per-user desktop behavior, edit `home/*`.
- If the change affects system services, boot, networking, hardware, users, or machine-wide packages, edit top-level NixOS modules such as `configuration.nix`, `services.nix`, `programs/*.nix`, or `options/*.nix`.
- If the change is specific to the `archie` host, keep it inside `hosts/archie/*` unless it is clearly shared.
- Do not add unrelated settings directly to `flake.nix`; keep `flake.nix` focused on inputs and system wiring.

## Existing Structure Conventions
- Aggregator files such as `home/default.nix`, `home/programs/default.nix`, `programs/default.nix`, and `options/default.nix` are used to keep modules split. Preserve that pattern.
- Prefer adding a focused module file and wiring it into the relevant `default.nix` when a concern does not fit an existing module cleanly.
- Avoid duplicating the same concern in both Home Manager and NixOS unless the distinction is intentional.

## Validation
- Before proposing a switch, prefer evaluation/build checks first.
- For the primary system:
  - `nix build .#nixosConfigurations.nixos.config.system.build.toplevel --no-link`
- For the `archie` host:
  - `nix build .#nixosConfigurations.archie.config.system.build.toplevel --no-link`
- If only formatting is needed, use the formatter already configured in the repo or the smallest existing formatting command available.
- Do not run `nixos-rebuild switch` or any destructive system-changing command unless explicitly asked.

## Working Rules
- Check `git status --short` before editing. The worktree may already contain user changes.
- Never revert unrelated user edits.
- Prefer `rg` for codebase search.
- Keep comments minimal and only where the Nix logic is genuinely non-obvious.
- Match the existing formatting style in nearby files.

## Notes Specific To This Repo
- `flake.nix` currently points `nixpkgs` at a local path input: `/home/art/Projects/nixpkgs`. Do not replace that with a remote input unless explicitly requested.
- Home Manager is integrated through the NixOS configuration for the `nixos` host rather than exposed as a standalone flake output.
- `programs.nh.flake` already points to `/home/art/.config/home-manager`, so commands and examples should assume this repository root.
