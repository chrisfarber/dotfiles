brewdir=/opt/homebrew

if [[ ! -d $brewdir ]]; then
  echo "Homebrew is not installed in $brewdir. Skipping."
  exit 0
fi

zsh_env 02 homebrew_env.sh

zsh_rc 03 homebrew_profile_d.sh