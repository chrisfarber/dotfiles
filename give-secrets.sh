#!/usr/bin/env zsh
source ./_lib/lib.sh

to_host=$1
if [[ -z $to_host ]]; then
  echo "usage: $0 user@my-ssh-host"
  exit 2
fi

files=(
  ~/.ssh/config.d/hosts
  ~/.ssh/keys/*
)

echo "This will copy your secrets to:"
echo "Host: $to_host"
echo
for file in $files; do
  echo $file
done
echo

if ! confirm "Continue:"; then
  exit 1
fi

if [[ -e ~/.ssh/config.d/hosts ]]; then
  scp -p ~/.ssh/config.d/hosts $to_host:~/.ssh/config.d/hosts
fi

scp -p ~/.ssh/keys/* $to_host:~/.ssh/keys/
