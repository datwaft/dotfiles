#!/usr/bin/env bash

if [[ "$SSH_CONNECTION" ]] && [[ "$SSH_AUTH_SOCK" ]]; then
  ssh-keygen "$@"
elif [ -x "/Applications/1Password.app/Contents/MacOS/op-ssh-sign" ] ; then
  /Applications/1Password.app/Contents/MacOS/op-ssh-sign "$@"
elif [ -x "/opt/1Password/op-ssh-sign" ]; then
  /opt/1Password/op-ssh-sign
fi
