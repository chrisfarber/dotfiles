brewdir=/opt/homebrew

if [[ ! -d $brewdir ]]; then
  echo "Homebrew is not installed in $brewdir. Skipping."
  exit 0
fi

# once in env so it's always available
zsh_env 02 homebrew_env.sh

# then again in rc so that macOS's /etc/zprofile does not step on it.
# :|
zsh_rc 02 homebrew_env.sh

zsh_rc 03 homebrew_profile_d.sh