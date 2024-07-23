#!/bin/zsh
##
## Script to setup Mission Control's configurations
##

handle_mission_control_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Mission Control"

  if test "$dry_run" -eq 0; then
    # Automatically rearrange Spaces based on most recent use
    defaults write com.apple.dock mru-spaces -bool true
    
    # When switching to an application, switch to a Space with open
    # windows for the application
    defaults write NSGlobalDomain AppleSpacesSwitchOnActivate -bool true

    # Group windows by application
    defaults write com.apple.dock expose-group-by-app -bool false
    
    # Displays have separate Spaces
    defaults write com.apple.spaces spans-displays -bool false
  fi

  ### Finishing touches
  print_step "Mission Control — DONE!"
}

handle_mission_control_dotfiles $1

unset -f handle_mission_control_dotfiles