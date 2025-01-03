if [[ -e /opt/homebrew/bin/brew ]]; then
  zsh_env 02 homebrew_apple_silicon_env.sh
  zsh_rc 02 homebrew_apple_silicon_rc.sh
fi

if [[ -e /usr/local/bin/brew ]]; then
  zsh_env 02 homebrew_intel_env.sh
  zsh_rc 02 homebrew_intel_rc.sh
fi