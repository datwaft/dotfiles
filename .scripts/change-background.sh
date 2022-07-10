if [ "$1" == "dark" ]; then
  tmux source-file ~/.config/tmux/theme_dark.conf
  for pipe in /tmp/nvim*.pipe; do
    nvim --server $pipe --remote-send ':set background=dark<cr>'
  done
else
  tmux source-file ~/.config/tmux/theme_light.conf
  for pipe in /tmp/nvim*.pipe; do
    nvim --server $pipe --remote-send ':set background=light<cr>'
  done
fi
