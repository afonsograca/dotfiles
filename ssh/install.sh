#!/bin/sh
##
## Script to import previously created SSH keys and set SSH configurations
##
trap '' TERM

handle_ssh() {

  local dry_run=$2

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  local build_dir="$base_dir/build/ssh"
  mkdir -p $build_dir
  
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
    cp "config" "$build_dir/config"
    symlink_files "$build_dir/config" "$HOME/.ssh" "" false
  fi
  
  ### Finishing touches
  print_header_footer "Step: SSH — DONE!"
}

handle_ssh $1 $2

unset -f handle_ssh

trap - TERM