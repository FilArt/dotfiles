#!/bin/bash
LAYOUT=$(hyprctl devices | grep logitech-usb-receiver -A 5 | grep 'main: yes' -B 3 | grep keymap | awk '{print $3}')
[[ "$LAYOUT" == "English" ]] && echo "us" || echo "ru"
