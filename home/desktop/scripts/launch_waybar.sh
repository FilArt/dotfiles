#!/usr/bin/env bash
# Watches Waybar config/style files and reloads Waybar automatically on changes

WATCH_DIR="$HOME/.config/home-manager/home/desktop/waybar"
 
# Start Waybar in the background (if not already running)
if ! pgrep -x "waybar" >/dev/null; then
  echo "Starting Waybar..."
  waybar &
  WAYBAR_PID=$!
  echo "Waybar started (PID: $WAYBAR_PID)"
fi

echo "Watching for changes in: ${CONFIG_FILES[@]}"

# Watch for file modifications, moves, or creates
inotifywait -m -e close_write $WATCH_DIR 2>/dev/null | while read -r path event file; do
  echo "Detected change in $path$file ($event). Reloading Waybar..."
  pkill -SIGUSR2 waybar
done

