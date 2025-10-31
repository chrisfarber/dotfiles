jwt-decode() {
  local token="${1:-$(pbpaste)}"
  jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< "$token"
}
