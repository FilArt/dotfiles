#!/usr/bin/env bash

current_temp=$(cat /tmp/.temp)
temp_min=3000
temp_max=7000

case $current_temp in
$temp_max) new_temp=$temp_min ;;
*) new_temp=$temp_max ;;
esac

if [[ -n $(pgrep hyprsunset) ]]; then
	pkill hyprsunset
fi
hyprsunset --temperature "$new_temp" &
disown
echo "$new_temp" >/tmp/.temp
