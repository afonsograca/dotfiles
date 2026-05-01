#!/bin/sh
##
## Script to import previously created SSH keys and set SSH configurations
##
trap '' TERM

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_ssh() {
  local dry_run=$2
  local build_dir="$DOTFILES_PATH/build/ssh"
  mkdir -p $build_dir

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
