
if [[ -n `whence rbenv` ]]; then
  eval "$(rbenv init -)"
fi
if [[ -n `whence direnv` ]]; then
  eval "$(direnv hook zsh)"
fi
if [[ -n `whence nodenv` ]]; then
  eval "$(nodenv init -)"
fi

if [[ -n `whence pyenv` ]]; then
    eval "$(pyenv init -)"
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"
fi
