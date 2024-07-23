#!/bin/zsh
##
## Script to setup Date & Time's configurations
##

handle_date_time_dotfiles() {
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
  print_step "Date & Time"

  if test "$dry_run" -eq 0; then

    activate_sudo

    # Set date & time automatically
    # TODO
    # sudo sntp -sS time.apple.com

    # Set time zone automatically
    # TODO

  fi

  ### Finishing touches
  print_step "Date & Time — DONE!"
}

handle_date_time_dotfiles $1

unset -f handle_date_time_dotfiles