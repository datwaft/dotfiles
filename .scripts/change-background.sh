if [ -z "$1" ]; then
  defaults read -g AppleInterfaceStyle &> /dev/null
  if [[ $? -eq 0 ]]; then
    mode="dark"
  else
    mode="light"
  fi
else
  mode=$1
fi

if [ "$mode" == "dark" ]; then
  tmux source-file ~/.config/tmux/theme_dark.conf
  if compgen -G '/tmp/nvim_*.pipe' > /dev/null; then
    for pipe in /tmp/nvim_*.pipe; do
      /usr/local/bin/nvim --server $pipe --remote-send ':set background=dark<cr>'
    done
  fi
else
  tmux source-file ~/.config/tmux/theme_light.conf
  if compgen -G '/tmp/nvim_*.pipe' > /dev/null; then
    for pipe in /tmp/nvim_*.pipe; do
      /usr/local/bin/nvim --server $pipe --remote-send ':set background=light<cr>'
    done
  fi
fi
