#!/usr/bin/env zsh

symlink "zshenv"
symlink "zshrc"
symlink "cfgit.zsh"

zsh_rc 01 "aliases.sh"

zsh_env 01 "local-bin.sh"

zsh_env 05 "version_managers.sh"

if macos; then
  # here is the magic that works around /usr/libexec/path_helper:
  zsh_env 00 "macos_path_helper_capture_start.sh"
  zsh_env 99 "macos_path_helper_capture_end.sh"
  zsh_rc 99 "macos_path_helper_fix.sh"
fi
