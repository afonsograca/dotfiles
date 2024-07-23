#!/bin/zsh
##
## Script to setup Siri's configurations
##

handle_siri_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Siri"

  if test "$dry_run" -eq 0; then
    # Disable Siri
    defaults write com.apple.assistant.support "Assistant Enabled" -bool false
  fi

  ### Finishing touches
  print_step "Siri — DONE!"
}

handle_siri_dotfiles $1

unset -f handle_siri_dotfiles