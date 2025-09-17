#!/usr/bin/env zsh

# Skip if this fix has already been applied
if [[ -n "$CFARBER_MACOS_PATH_HELPER_WORKAROUND_COMPLETE" ]]; then
  return 0
fi

disturbed_path=($path[@])
PATH=$KNOWN_USER_ENV_PATH
for dir in $disturbed_path; do
  if [[ $path[(Ie)$dir] -eq 0 ]]; then
    path+=($dir)
  fi
done

export path
unset disturbed_path
unset dir

# Mark that this fix has been applied
export CFARBER_MACOS_PATH_HELPER_WORKAROUND_COMPLETE=1
