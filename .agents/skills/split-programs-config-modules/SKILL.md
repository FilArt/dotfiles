---
name: split-programs-config-modules
description: Split monolithic NixOS/Home Manager `programs.*` configuration into focused module files and wire imports. Use when a user asks to refactor, modularize, organize, or clean up `programs` config in `.nix` files (for example `programs.nix`, `home.nix`, `home/programs/default.nix`).
---

# Split Programs Config Modules

Refactor `programs.*` settings into separate modules while preserving behavior.

## Workflow

### 1. Inventory current `programs.*` definitions

Find all current declarations before changing files.

```bash
rg -n "programs\\." -g "*.nix"
```

Map each declaration to a target module path by concern (shell, editors, terminal, gaming, etc).

### 2. Define module layout

Prefer one option group per file.

Use folder-local `default.nix` as a list-style aggregator:

```nix
[
  ./direnv.nix
  ./zsh.nix
  ./steam.nix
]
```

Keep an existing top-level compatibility file as a thin import wrapper when needed:

```nix
{
  imports = import ./programs;
}
```

### 3. Move declarations

Create target module files and move the exact option blocks without semantic changes.

Rules:
- Preserve values and nesting exactly.
- Avoid duplicate definitions of the same option path.
- Keep unrelated config outside this refactor.

### 4. Update import graph

Update import lists to include new module files.

Typical patterns:
- `imports = [ ./home ]` in root home module.
- `imports = [ ... ] ++ import ./programs;` in grouped modules.
- `imports = [ ./nix.nix ./programs.nix ... ]` in system configuration.

### 5. Validate

Run a flake check that includes untracked files during the refactor:

```bash
nix flake check --no-build path:.
```

If `git+file` flake input fails to see new files, continue with `path:.` for validation and mention why.

### 6. Report concise results

Summarize:
- Files added/updated.
- Behavior-preserving guarantees.
- Validation command and outcome.
- Remaining warnings (if any).

## Quick Checklist

- `programs.*` declarations inventoried with `rg`.
- New modules grouped by concern.
- Aggregators (`default.nix` or compatibility wrapper) updated.
- Source files cleaned of moved declarations.
- `nix flake check --no-build path:.` executed.
