#!/bin/sh
##
## Script to deal with git 
##

handle_git_dotfiles() {
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.."; pwd)"
  fi
  local git_dir="$base_dir/git"
  
  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: Git" $1

  ### Create gitignore_global.lock
  local gitignore="$(cat "$base_dir/git/gitignore_global" 2>/dev/null)"

  for file in "$base_dir"/extra/{**,}/gitignore_global_local; do
    local gitignore="${gitignore}\n\n$(cat "$file" 2>/dev/null)"
  done
  unset file

  printf "$gitignore" > "$git_dir/gitignore_global.lock"

  ### Symlink gitignore_global
  symlink_files "$git_dir/gitignore_global.lock" "$HOME" "gitignore_global"
  printf ""

  ### Finishing touches
  print_header_footer "Step: Git — DONE!"
}

handle_git_dotfiles "$1"
unset -f handle_git_dotfiles
