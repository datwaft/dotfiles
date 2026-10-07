#!/bin/zsh

jj_bin=$(command -v jj 2>/dev/null) || exit 0

if ! $jj_bin --ignore-working-copy root &>/dev/null; then
  exit 0
fi

$jj_bin --quiet util snapshot
