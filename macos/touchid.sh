#!/bin/zsh
##
## Script to setup Touch Id's configurations
##

handle_touch_id_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  if ! command -v activate_sudo >/dev/null 2>&1; then
    source "$base_dir/bin/sudo.sh"
  fi
  
  ### Intro
  print_step "Touch Id"

  if test "$dry_run" -eq 0; then
    activate_sudo

    # Turn on Touch ID in general
    bioutil --write --system --function 1
    
    # Turn on Touch ID unlock capabilities and ApplePay
    bioutil --write --unlock 1 --applepay 1
  fi

  ### Finishing touches
  print_step "Touch Id — DONE!"
}

handle_touch_id_dotfiles $1

unset -f handle_touch_id_dotfiles