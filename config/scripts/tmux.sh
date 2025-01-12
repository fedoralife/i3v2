#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/.config ~/DEV ~/scripts ~/work ~/personal -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# Check if tmux is not running, create new session
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    # Send 'nvim' to start Neovim after opening the session
    tmux send-keys -t $selected_name "nvim" C-m
    # Kill the window after Neovim exits
    tmux send-keys -t $selected_name "exit" C-m
    exit 0
fi

# If the session doesn't exist, create it
if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
    # Send 'nvim' to start Neovim after opening the session
    tmux send-keys -t $selected_name "nvim" C-m
    # Kill the window after Neovim exits
    tmux send-keys -t $selected_name "exit" C-m
fi

# Switch to the session
tmux switch-client -t $selected_name

