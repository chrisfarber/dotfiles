#!/usr/bin/env zsh

symlink "zshenv"
symlink "zshrc"

# removing in favor of starship
unsymlink ".p10k.zsh"
unsymlink ".cfgit.zsh"

zsh_rc 01 "aliases.sh"

zsh_env 01 "local-bin.sh"

directory_with_mode ".config" 700
symlink "starship.toml" ".config/starship.toml"
zsh_rc 10 "starship.sh"

if macos; then
  # here is the magic that works around /usr/libexec/path_helper:
  # zsh_env 00 "macos_path_helper_capture_start.sh"
  # zsh_env 99 "macos_path_helper_capture_end.sh"
  # zsh_rc 99 "macos_path_helper_fix.sh"

  unsymlink ".zshenv.d/00-macos_path_helper_capture_start.sh"
  unsymlink ".zshenv.d/99-macos_path_helper_capture_end.sh"
  unsymlink ".zshrc.d/99-macos_path_helper_fix.sh"
fi
