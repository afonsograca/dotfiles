#!/bin/sh
##
## Script to deal with git 
##

handle_git_dotfiles() {

  local dry_run=$2

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

  if test "$dry_run" -eq 0; then
    print_substep "NOT DRY RUN"
    # ### Create gitconfig.lock
    # cat "$git_dir/gitconfig" > "$git_dir/gitconfig.lock" 2>/dev/null

    # for file in "$base_dir"/extra/{**/,}*gitconfig_local; do
    #   if [ -s "$file" ]; then
    #     (echo; echo; cat "$file") >> "$git_dir/gitconfig.lock" 2>/dev/null
    #   fi
    # done
    # unset file

    # ### Symlink gitconfig
    # symlink_files "$git_dir/gitconfig.lock" "$HOME" "gitconfig"

    # ### Create gitignore_global.lock
    # cat "$git_dir/gitignore_global" > "$git_dir/gitignore_global.lock" 2>/dev/null

    # for file in "$base_dir"/extra/{**/,}gitignore_global_local; do
    #   if [ -s "$file" ]; then
    #     (echo; echo; cat "$file") >> "$git_dir/gitignore_global.lock" 2>/dev/null
    #   fi
    # done
    # unset file

    # ### Symlink gitignore_global
    # symlink_files "$git_dir/gitignore_global.lock" "$HOME" "gitignore_global"
  fi

  ### Finishing touches
  print_header_footer "Step: Git — DONE!"
}

handle_git_dotfiles $1 $2
unset -f handle_git_dotfiles
