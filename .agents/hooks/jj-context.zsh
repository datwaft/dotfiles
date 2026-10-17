#!/usr/bin/env zsh
set -eu

directory=$(jq -er '.cwd')
cd -- "$directory"
directory=${PWD:A}

while [[ ! -d "$directory/.jj" ]]; do
  [[ -e "$directory/.git" || "$directory" == / ]] && exit 0
  directory=${directory:h}
done

printf '%s\n' \
  "Jujutsu workspace: $directory." \
  "Use jj for version-control operations in this workspace, even when .git is also present." \
  "Load and follow the jj-vcs skill before version-control work." \
  "Recheck when operating on another repository."
