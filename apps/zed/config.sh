#!/bin/zsh
##
## Script to setup Zed's configuration
##

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_zed_dotfiles() {
  local dry_run=$1

  ### Intro
  print_step "Zed"

  if test "$dry_run" -eq 0; then
    symlink_files "$DOTFILES_PATH/apps/zed/settings.json" "$HOME/.config/zed" "" false
  fi

  ### Finishing touches
  print_step "Zed — DONE!"
}

handle_zed_dotfiles $1

unset -f handle_zed_dotfiles
