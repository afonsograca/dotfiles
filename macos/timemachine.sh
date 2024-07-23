#!/bin/sh
##
## Script to setup Time Machine's configurations
##

handle_time_machine_dotfiles() {
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
  print_step "Time Machine"

  if test "$dry_run" -eq 0; then

    activate_sudo

    # Back Up Automatically
    tmutil enable

    # Prevent Time Machine from prompting to use new hard drives as backup volume
    defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
  fi

  ### Finishing touches
  print_step "Time Machine — DONE!"
}

handle_time_machine_dotfiles $1

unset -f handle_time_machine_dotfiles
