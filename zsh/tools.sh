if [[ ! -z $(whence code) ]]; then
  export EDITOR="code -w"
  export VISUAL="code -w"
else
  export EDITOR=vim
  export VISUAL=vim
fi

export PAGER=less