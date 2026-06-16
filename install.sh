#!/usr/bin/env zsh
source ./_lib/lib.sh

echo "Configuring environment"

zparseopts -D -E -F -- n=dry_run
if [[ ! -z $dry_run ]]; then
  echo "Dry run."
  DRY_RUN=1
fi

step "dotlocal"
step "zsh"
step "ssh"
step "git"
step "helix"
step "zellij"
step "jj"

if macos; then
  step "homebrew"
  step "ghostty"
fi

#step "emacs"
