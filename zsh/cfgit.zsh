setopt prompt_subst

typeset -A _cfgit_info

_cfgit_update_info() {
  _cfgit_info=()

  local gitdir="$(git rev-parse --git-dir 2>/dev/null)"
  if [ $? -ne 0 ] || [ -z "$gitdir" ]; then
    return
  fi

  _cfgit_info[dir]="$gitdir"
  _cfgit_info[bare]=$(git rev-parse --is-bare-repository)
  _cfgit_info[inwork]=$(git rev-parse --is-inside-work-tree)
}
_cfgit_update_info

_cfgit_is_git() {
  if [[ -z "$_cfgit_info[dir]" ]]; then
    return 1;
  else
    return 0;
  fi
}

_cfgit_branch() {
  _cfgit_is_git || return
  local branch_name
  branch_name="$(git symbolic-ref HEAD 2>/dev/null)" ||
    branch_name="no branch"
  branch_name="${branch_name##refs/heads/}"
  if [[ -n $branch_name[100] ]]; then
    branch_name="$branch_name[0,97]..."
  fi
  echo "$branch_name"
}

_cfgit_num_stashes() {
  _cfgit_is_git || return
  echo `git stash list | wc -l`
}

_cfgit_update_divergence() {
  _cfgit_is_git || return
  local ahead=0
  local behind=0
  local branch="`git name-rev --name-only HEAD`"
  local remote_branch="`git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)`"
  for line in `git rev-list --left-right $remote_branch...HEAD 2> /dev/null`; do
    if [[ $line[1] == ">" ]]; then
      ahead=$(( $ahead + 1))
    fi
    if [[ $line[1] == "<" ]]; then
      behind=$(( $behind + 1))
    fi
  done
  _cfgit_info[ahead]=$ahead
  _cfgit_info[behind]=$behind
}

_cfgit_is_dirty() {
  _cfgit_is_git || return
  if [[ -z `git status --porcelain` ]]; then
    return 1;
  else
    return 0;
  fi
}

cfgit_prompt() {
  _cfgit_is_git || return
  echo -n "(%F{green}±%f %F{blue}$(_cfgit_branch)%f"
  if _cfgit_is_dirty; then
    echo -n "%F{red}*%f"
  fi
  # 2019-09-19 -- disabling this because for two reasons:
  #               1. the star is annoying in my current font
  #               2. i just don't care about stashes that much
  # local num_stashes=$(_cfgit_num_stashes)
  # if (( $num_stashes > 0 )); then
  #   echo -n "%F{magenta}★${num_stashes}%f"
  # fi
  _cfgit_update_divergence
  local num_ahead=$_cfgit_info[ahead]
  if (( $num_ahead > 0 )); then
    echo -n "%F{green}↑${num_ahead}%f"
  fi
  local num_behind=$_cfgit_info[behind]
  if (( $num_behind > 0 )); then
    echo -n "%F{red}↓${num_behind}%f"
  fi
  echo -n ") "
}

_cfgit_chpwd_hook() {
  _cfgit_update_info
}

if [[ -n `whence git` ]]; then
  autoload -U add-zsh-hook
  add-zsh-hook chpwd _cfgit_chpwd_hook
fi
