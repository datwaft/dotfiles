#!/usr/bin/env bash

# Split the current tmux pane automatically depending on which dimension is bigger
# Requires: tmux

width="$(tmux display -p "#{pane_width}")"
height=$(("$(tmux display -p "#{pane_height}")" * 3))

if [ "$width" -gt "$height" ]; then
  tmux split-window -h "$@"
else
  tmux split-window -v "$@"
fi
