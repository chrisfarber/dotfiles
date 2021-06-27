# capture the paths after all our init

if [[ -z $KNOWN_USER_ENV_PATH ]]; then
  local path_after_user_env=($path[@])
  local user_env_paths=()
  for dir in $path_after_user_env; do
    if [[ $path_before_user_env[(Ie)$dir] -gt 0 ]] continue
    user_env_paths+=($dir)
  done
  export KNOWN_USER_ENV_PATH=${(j.:.)user_env_paths}
  unset path_after_user_env
  unset user_env_paths
fi