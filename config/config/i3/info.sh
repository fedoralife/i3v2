#!/bin/bash

# Path to the file containing keybindings
KEYBINDINGS_FILE="$HOME/help.txt"

# Set GTK_THEME to a dark variant
export GTK_THEME="Breeze:dark"

# Check if the file exists
if [[ -f "$KEYBINDINGS_FILE" ]]; then
    # Display the keybindings using zenity and block until it closes
    zenity --info \
        --title="Keybindings" \
        --text="$(cat "$KEYBINDINGS_FILE")" \
        --width=400 \
        --height=300 \
        --no-wrap
else
    zenity --error \
        --title="Error" \
        --text="Keybindings file not found: $KEYBINDINGS_FILE" \
        --no-wrap
fi

