#!/bin/zsh
##
## Script to setup Software Updates' configurations
##

handle_software_update_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Software Updates"

  if test "$dry_run" -eq 0; then
    # TODO
  fi

  ### Finishing touches
  print_step "Software Updates — DONE!"
}

handle_software_update_dotfiles $1

unset -f handle_software_update_dotfiles