#!/usr/bin/env zsh

symlink "zshenv"
symlink "zshrc"
symlink "cfgit.zsh"

zsh_rc 01 "aliases.sh"

zsh_env 01 "local-bin.sh"

zsh_env 05 "version_managers.sh"