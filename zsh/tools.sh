if [[ ! -z $(whence code) ]]; then
  export EDITOR="code -w"
  export VISUAL="code -w"
else
  export EDITOR=vim
  export VISUAL=vim
fi

export PAGER=less

jwt-decode() {
  jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1
}
