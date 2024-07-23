#!/bin/zsh
##
## Script to setup Spotlight's configurations
##

handle_spotlight_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Spotlight"

  if test "$dry_run" -eq 0; then
    # Search all results 
    defaults delete com.apple.Spotlight orderedItems >/dev/null 2>&1
  fi

  ### Finishing touches
  print_step "Spotlight — DONE!"
}

handle_spotlight_dotfiles $1

unset -f handle_spotlight_dotfiles