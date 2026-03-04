---
name: nixos-hardware-tuning-agent
description: Audit and tune NixOS hardware-related configuration for performance, latency, thermals, and stability. Use when a user asks to optimize system hardware behavior or review NixOS settings for swap strategy, AMD/NVIDIA GPU configuration, PipeWire/WirePlumber latency, CPU/power management, or desktop/gaming responsiveness.
---

# NixOS Hardware Tuning Agent

Review existing NixOS and Home Manager configuration, identify hardware tuning opportunities, and propose concrete, low-risk changes.

## Repo Defaults

Use these defaults unless the user overrides them:

- Hardware profile: AMD Ryzen 5 8600G + NVIDIA RTX 4060 (desktop PC).
- Memory profile: 64 GB RAM desktop, so do not recommend `zramSwap` by default.
- Rebuild/apply commands: use `nh` (`nh os build`, `nh os test`, `nh os switch`) instead of `nixos-rebuild`.
- PipeWire baseline: assume already tuned; only suggest changes when a specific gap or problem is found.

## Workflow

### 1. Build hardware and workload context

Collect enough context before recommending anything:

```bash
hostnamectl
lscpu
free -h
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
lspci -nnk | rg -i "vga|3d|display|audio|network"
```

Inspect relevant Nix files, commonly:
- `configuration.nix`
- `options/*.nix`
- `home.nix`
- `home/**/*.nix`

Ask for intended workload if missing (gaming, low-latency audio, workstation, mixed use).

### 2. Audit high-impact tuning areas

Check these first:

1. Swap strategy (for this profile, prefer no zram unless memory pressure, heavy VMs/containers, or specific OOM events are observed).
2. GPU stack for AMD iGPU + NVIDIA dGPU (driver path, PRIME/offload path if relevant, OpenGL/Vulkan/VA-API).
3. PipeWire / WirePlumber realtime and latency behavior.
4. CPU governor and power management (`power-profiles-daemon`, thermals, boost behavior).
5. IO/filesystem or scheduler knobs only when benchmark evidence supports it.

### 3. Apply current PipeWire guidance

Use conservative recommendations grounded in current official docs:

1. Keep realtime scheduling enabled (`security.rtkit.enable = true`) and verify effective RT behavior.
2. Do not force `default.clock.allowed-rates` globally unless there is a measured reason; defaults avoid known issues in some setups.
3. Prefer targeted latency tuning (`node.latency`, client/stream rules) over forcing very low global quantum.
4. If idle resume/pop issues exist, tune WirePlumber `session.suspend-timeout-seconds` per-device (set `0` only when needed).

### 4. Recommend changes with safety notes

For each suggestion:

1. State current behavior (or missing config).
2. Suggest exact Nix option-level change.
3. Explain expected gain and tradeoff.
4. Tag confidence: `high`, `medium`, or `needs-benchmark`.

Prefer conservative defaults first. Avoid risky kernel/sysctl tweaks unless there is clear evidence they are needed.

### 5. Provide patch-ready snippets

When user wants changes, output minimal module snippets they can drop into existing files. Keep changes scoped and reversible.

### 6. Validate and verify

After proposing or applying changes, use `nh`:

```bash
nh os build
nh os test
```

Recommend quick checks tied to each change:
- `swapon --show` and `free -h` for swap strategy
- `pw-top` and `systemctl --user status pipewire wireplumber` for audio
- `glxinfo -B`, `vulkaninfo --summary`, `nvidia-smi` for GPU
- `powerprofilesctl get` and thermal/frequency monitors for power/thermals

## Output Format

Return recommendations in this order:

1. `Top 3 Improvements`
2. `Suggested Nix Changes`
3. `Validation Steps`
4. `Risks/Tradeoffs`

Keep recommendations explicit and grounded in detected hardware and current config.
