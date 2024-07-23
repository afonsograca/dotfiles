#!/bin/zsh
##
## Script to setup Keyboard's configurations
##

handle_keyboard_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Keyboard"

  if test "$dry_run" -eq 0; then

    # Key Repeat
    defaults write NSGlobalDomain KeyRepeat -int 2

    # Delay Until Repeat
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Adjust keyboard brightness in low light
    # TODO

    # Turn keyboard backlight off after

    # Press fn key to

    # Use F1, F2, etc. keys as standard function keys

    # Correct spelling automatically

    # Capitalise words automatically

    # Add full stop with double-space

    # Use smart quotes and dashes

    # Automatically switch to a document's input source

    # Dictation
  fi

  ### Finishing touches
  print_step "Keyboard — DONE!"
}

handle_keyboard_dotfiles $1

unset -f handle_keyboard_dotfiles