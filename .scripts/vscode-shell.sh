#!/bin/bash
session_name="vscode`pwd | md5`"
tmux attach-session -d -t $session_name || tmux new-session -s $session_name
