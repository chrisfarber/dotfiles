#!/usr/bin/env zsh

disturbed_path=($path[@])
PATH=$KNOWN_USER_ENV_PATH
for dir in $disturbed_path; do
  if [[ $path[(Ie)$dir] -eq 0 ]]; then
    path+=($dir)
  fi
done

export path
unset disturbed_path
unset dir
