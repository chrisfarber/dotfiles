#!/usr/bin/env zsh

git_clone "https://github.com/romkatv/powerlevel10k.git" ".powerlevel10k"

symlink "zshenv"
symlink "zshrc"
symlink "p10k.zsh"

# removing in favor of powerlevel
unsymlink ".cfgit.zsh"

zsh_rc 01 "aliases.sh"

zsh_env 01 "local-bin.sh"

if macos; then
  # here is the magic that works around /usr/libexec/path_helper:
  # zsh_env 00 "macos_path_helper_capture_start.sh"
  # zsh_env 99 "macos_path_helper_capture_end.sh"
  # zsh_rc 99 "macos_path_helper_fix.sh"

  unsymlink ".zshenv.d/00-macos_path_helper_capture_start.sh"
  unsymlink ".zshenv.d/99-macos_path_helper_capture_end.sh"
  unsymlink ".zshrc.d/99-macos_path_helper_fix.sh"
fi
