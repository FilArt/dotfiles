#!/usr/bin/env bash


systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=qtile

systemctl --user stop pipewire wireplumber xdg-desktop-portal xdg-desktop-portal-wlr
systemctl --user start wireplumber
#systemctl --user restart xdg-desktop-portal xdg-desktop-portal-wlr
#systemctl --user start pulseaudio

# kanshi workaround
if ! systemctl --user is-active --quiet kanshi; then
    systemctl --user restart kanshi
fi

pkill wl-paste
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &
