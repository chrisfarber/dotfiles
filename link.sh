#!/usr/bin/env zsh

ensure_symlink() {
  local link_path="$1"
  local target_path="$2"

  # Check if both arguments are provided
  if [[ -z "$link_path" || -z "$target_path" ]]; then
    echo "Usage: ensure_symlink <link_path> <target_path>"
    return 1
  fi

  # If link exists but is not a symlink, backup and remove it
  if [[ -e "$link_path" && ! -L "$link_path" ]]; then
    mv "$link_path" "${link_path}.backup"
  fi

  # Create or update symlink if needed
  if [[ ! -L "$link_path" || "$(readlink "$link_path")" != "$target_path" ]]; then
    ln -sfn "$target_path" "$link_path"
    echo "Created symlink: $link_path -> $target_path"
  else
    echo "Symlink exists: $link_path -> $target_path"
  fi
}

mkdir -p local

ensure_symlink "local/ssh" "$HOME/.ssh"
ensure_symlink "local/zshrc.d" "$HOME/.zshrc.d"
ensure_symlink "local/zshenv.d" "$HOME/.zshenv.d"