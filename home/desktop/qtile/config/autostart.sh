#!/usr/bin/env bash

sleep 1

systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=qtile

pkill wl-paste || true
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

nix-shell -p kanshi --run kanshi
