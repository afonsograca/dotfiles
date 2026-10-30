#!/bin/zsh
##
## Script to setup Ghostty's configuration
##

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_ghostty_dotfiles() {
  local dry_run=$1

  ### Intro
  print_step "Ghostty"

  if test "$dry_run" -eq 0; then
    symlink_files "$DOTFILES_PATH/apps/ghostty/config" "$HOME/.config/ghostty" "" false

    # Ghostty reads this file after ~/.config/ghostty/config, so its values win.
    local legacy="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    if test -f "$legacy"; then
      print_substep "Warning: delete $legacy, it overrides the linked config"
    fi
  fi

  ### Finishing touches
  print_step "Ghostty — DONE!"
}

handle_ghostty_dotfiles $1

unset -f handle_ghostty_dotfiles
