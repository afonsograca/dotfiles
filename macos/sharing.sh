#!/bin/zsh
##
## Script to setup Sharing's configurations
##

handle_sharing_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Sharing"

  if test "$dry_run" -eq 0; then
    # TODO
  fi

  ### Finishing touches
  print_step "Sharing — DONE!"
}

handle_sharing_dotfiles $1

unset -f handle_sharing_dotfiles