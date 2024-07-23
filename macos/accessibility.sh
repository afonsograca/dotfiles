#!/bin/zsh
##
## Script to setup Accessibility's configurations
##

handle_accessibility_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Accessibility"

  if test "$dry_run" -eq 0; then
    # TODO
  fi

  ### Finishing touches
  print_step "Accessibility — DONE!"
}

handle_accessibility_dotfiles $1

unset -f handle_accessibility_dotfiles