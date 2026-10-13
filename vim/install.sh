#!/bin/sh
##
## Script to set Vim configurations
##
trap '' TERM

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_vim() {
  local dry_run=${2:-0}

  ### Intro
  print_header_footer "Step: Vim" $1

  if test "$dry_run" -eq 0; then
    ### Symlink vimrc and exrc
    symlink_files "$DOTFILES_PATH/vim/vimrc" "$HOME" ""
    symlink_files "$DOTFILES_PATH/vim/exrc" "$HOME" ""
  fi

  ### Finishing touches
  print_header_footer "Step: Vim — DONE!"
}

handle_vim $1 $2

unset -f handle_vim

trap - TERM
