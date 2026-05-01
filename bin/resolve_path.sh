#!/bin/zsh
##
## Function to resolve the dotfiles root directory
##

# Resolve the dotfiles root directory from anywhere in the project structure
# This function works by looking for the main 'dotfiles' script file
# Usage: DOTFILES_PATH=$(resolve_path)
resolve_path() {
  local current_dir="$(pwd)"
  local search_dir

  # Start from the directory containing this script
  if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
    search_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  elif [[ -n "${funcfiletrace[1]:-}" ]]; then
    # Zsh equivalent using funcfiletrace
    search_dir="$(cd "$(dirname "${funcfiletrace[1]%:*}")/.." && pwd)"
  else
    # Fallback to current directory
    search_dir="$current_dir"
  fi

  # Walk up the directory tree looking for the dotfiles root
  while [[ "$search_dir" != "/" ]]; do
    if [[ -f "$search_dir/dotfiles" ]]; then
      echo "$search_dir"
      return 0
    fi
    search_dir="$(dirname "$search_dir")"
  done

  # Final fallback - assume standard location
  echo "$HOME/dotfiles"
  return 1
}
