#!/bin/bash

# Find directories recursively from the current directory, excluding dotfiles (and .config)
SELECTED_DIR=$(find . -type d \
  -not -path "*/\.*" | fzf --preview "ls -la {}" --height 40% --border)

# If a directory is selected, open it with Neovim
if [ -n "$SELECTED_DIR" ]; then
  nvim "$SELECTED_DIR"
else
  echo "No directory selected"
fi

