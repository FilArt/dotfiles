#!/usr/bin/env bash

systemctl --user import-environment WAYLAND_DISPLAY &
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
wpaperd &
