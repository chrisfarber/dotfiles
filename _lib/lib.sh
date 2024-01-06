function step {
  local root="$0:A:h"
  cd "$root/$1"
  print_section $1
  source ./install.sh
  if [[ $? -ne 0 ]]; then
  else
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
  if [[ -h $dest ]]; then
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

  # return early if the existing dest is a symlink to the source
  if [[ -h $dest && $(readlink $dest) == $source ]]; then
    echo "Symlink exists: $dest"
    return 0
  fi

  if confirm_overwrite $dest; then
    run ln -s $source $dest
  fi
}

function copy_once {
  local resolved
  resolve_file $1
  local source=$resolved
  local dest=$2
  if [[ -z $dest ]] dest=".$1"
  dest=$HOME/$dest
  if [[ ! -e $dest ]]; then
    run cp $source $dest
  fi
}

function directory {
  local dest=$HOME/$1
  if [[ -d $dest ]]; then
    echo "Directory exists: $dest"
    return 0
  elif [[ -e $dest ]]; then
    echo "$1 exists but is not a directory"
    if ! confirm "Overwrite as a directory"; then
      return 1
    fi
    run rm $dest
  fi
  run mkdir -p $dest
}

function directory_with_mode {
  directory $1
  if [[ $? ]]; then
    run chmod $2 $HOME/$1
  else
    return $?
  fi
}

function git_clone {
  local repo_url="$1"
  local dest="$HOME/$2"
  if [[ ! -e $dest ]]; then
    run git clone --depth=1 $repo_url $dest
  else
    if [[ ! -d $dest ]]; then
      echo "Does not appear to be a git checkout: $dest"
      return 1
    else
      pushd $dest
      local origin=$(git remote get-url origin)
      if [[ $repo_url == $origin ]]; then
        echo "Git repository $repo_url exists at $dest"
      else
        echo "WARNING: $dest does not appear to have git origin of $repo_url"
      fi
      popd
    fi
  fi
}

function symlink_zsh {
  local destdir=".zsh$1.d"
  directory $destdir
  local nn=$2
  local file=$3
  if [[ -z $nn ]] nn=99
  local dest="$destdir/$nn-$file"
  symlink $file $dest
}

function zsh_rc {
  symlink_zsh "rc" $1 $2
}

function zsh_env {
  symlink_zsh "env" $1 $2
}

function purge {
  echo "TODO: rm $1"
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
