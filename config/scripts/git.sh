#!/bin/bash

# Find directories containing .git recursively from the current directory
SELECTED_DIR=$(find . -type d -name ".git" -exec dirname {} \; | fzf --preview "ls -la {}" --height 40% --border)

# If a directory is selected, open it with Neovim
if [ -n "$SELECTED_DIR" ]; then
  nvim "$SELECTED_DIR"
else
  echo "No directory selected"
fi

