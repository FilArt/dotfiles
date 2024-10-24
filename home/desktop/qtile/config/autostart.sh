#!/usr/bin/env bash

# XDG Desktop Portal
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP
systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
systemctl --user start wireplumber

# Clipboard
pkill wl-paste || true
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# Display DPI
nix-shell -p --run kanshi
