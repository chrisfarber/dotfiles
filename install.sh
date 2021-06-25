#!/usr/bin/env sh

SOURCE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
DEST=~

function step() {
  cd "$SOURCE/$1"
  ./install.sh
  cd "$SOURCE"
}

step "zsh"