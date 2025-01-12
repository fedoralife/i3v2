#!/bin/bash

# Application class name
APP_NAME="EasyEffects"
LOG_FILE="$HOME/easyeffects_launch.log"

# Get all windows and their workspaces
WINDOW_INFO=$(i3-msg -t get_tree)

# Debugging: output the entire window info to the log
echo "$(date): Window tree output:" >> "$LOG_FILE"
echo "$WINDOW_INFO" >> "$LOG_FILE"

# Check if EasyEffects is running
WORKSPACE=$(echo "$WINDOW_INFO" | jq -r '.. | objects | select(.window_properties?.class == "'"$APP_NAME"'") | .workspace')

# Debugging: log the workspace search result
echo "$(date): Searching for workspace containing EasyEffects..." >> "$LOG_FILE"
echo "$(date): Found workspace: $WORKSPACE" >> "$LOG_FILE"

if [ -n "$WORKSPACE" ]; then
    # EasyEffects is already running; log this and do nothing
    echo "$(date): EasyEffects is already running." >> "$LOG_FILE"
else
    # EasyEffects not found; launch it
    echo "$(date): EasyEffects not found. Launching..." >> "$LOG_FILE"
    easyeffects & disown
fi

echo "$(date): Script execution finished" >> "$LOG_FILE"

