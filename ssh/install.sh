#!/bin/sh
##
## Script to import previously created SSH keys and set SSH configurations
##

handle_ssh() {

  local dry_run=$2

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.."; pwd)"
  fi
  local ssh_dir="$base_dir/ssh"
  
  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: SSH" $1
  
  if test "$dry_run" -eq 0; then
    ### Symlink config file
    symlink_files "$ssh_dir/config" "$HOME/.ssh" "" false
  fi
  
  ### Finishing touches
  print_header_footer "Step: SSH — DONE!"
}

handle_ssh $1 $2

unset -f handle_ssh