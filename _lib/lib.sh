function step {
  local root="$0:A:h"
  cd "$root/$1"
  # echo "==> $1"
  source ./install.sh
  if [[ $? -ne 0 ]]; then
    # echo "==> $1: failed"
  else
    # echo "==> $1: done."
  fi
  cd "$root"
}

function print_section {
  echo "\n===> $1\n"
}

function confirm {
  local cont
  while true; do
    vared -p "$1 (y/n): " cont
    cont=${cont:l}
    if [[ $cont == "yes" || $cont == "y" ]]; then
      return 0
    fi
    if [[ $cont == "no" || $cont == "n" ]]; then
      return 1
    fi
  done
}

function run {
  if [[ ! -v DRY_RUN ]]; then
    echo "RUN:" $@
    command $@
    return $?
  else
    echo "DRY RUN:" $@
  fi
  return 0
}

function confirm_overwrite {
  local dest=$1
  # is it a symlink?
  if [[ -h $dest ]]; then
    # echo "Removing existing symlink: $dest"
    run rm $dest
  elif [[ -e $dest ]]; then
    echo "File exists: $dest"
    if confirm "Overwrite it?"; then
      run rm $dest
    else
      echo "Skipping $dest"
      return 1
    fi
  fi
}

function resolve_file {
  local root="$0:A:h"
  resolved="$root/$1"
}

function symlink {
  local resolved
  resolve_file $1
  local source=$resolved
  local dest=$2
  if [[ -z $dest ]]; then
    dest=".$1"
  fi
  dest="$HOME/$dest"

  if confirm_overwrite $dest; then
    # echo "Symlinking: $dest"
    run ln -s $source $dest
  fi
}

function macos {
  if [[ $(uname) == "Darwin" ]]; then
    return 0
  fi
  return 1
}

function linux {
  if [[ $(uname) == "Linux" ]]; then
    return 0
  fi
  return 1
}
