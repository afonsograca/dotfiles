#!/bin/zsh
##
## Script to setup Screen Time's configurations
##

handle_screen_time_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Screen Time"

  if test "$dry_run" -eq 0; then
    # Turn off Screen time
    defaults delete com.apple.ScreenTimeAgent UsageGenesisDate >/dev/null 2>&1
  fi

  ### Finishing touches
  print_step "Screen Time — DONE!"
}

handle_screen_time_dotfiles $1

unset -f handle_screen_time_dotfiles