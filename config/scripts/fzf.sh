#!/bin/bash

# Find all directories excluding .git, then use fzf for selection
SELECTED_DIR=$(find ~ -type d \
  -not -path "*/\.git/*" \
  -not -path "*/\.*" \
  -or -path "$HOME/.config/*" | fzf --preview "ls -la {}" --height 40% --border)
# If a directory is selected, open it with Neovim
if [ -n "$SELECTED_DIR" ]; then
  nvim "$SELECTED_DIR"
else
  echo "No directory selected"
fi

