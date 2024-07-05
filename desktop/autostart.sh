#!/usr/bin/env bash

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=qtile
systemctl --user import-environment WAYLAND_DISPLAY &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
