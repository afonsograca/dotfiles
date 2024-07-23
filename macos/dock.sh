#!/bin/sh
##
## Script to setup the Dock's configurations
##

handle_dock_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Dock"

  if test "$dry_run" -eq 0; then
    # Set size of icons
    defaults write com.apple.dock tilesize -float 39

    # Enable magnification
    defaults write com.apple.dock magnification -bool true

    # Set magnificaton size
    defaults write com.apple.dock largesize -float 77

    # Set position
    defaults write com.apple.dock orientation -string bottom 

    # Set minimise effect
    defaults write com.apple.dock mineffect -string suck 

    # Enable minimise to icon
    defaults write com.apple.dock minimize-to-application -bool true

    # Enable launch animations
    defaults write com.apple.dock launchanim -bool true

    # Disable auto-hide
    defaults write com.apple.dock autohide -bool false

    # Enable launch animations
    defaults write com.apple.dock show-process-indicators -bool true

    # Hide recent apps
    defaults write com.apple.dock show-recents -bool false

    # Make Dock icons of hidden applications translucent
    defaults write com.apple.dock showhidden -bool true

    # Make Dock icons show expose when scrolled-up
    defaults write com.apple.dock scroll-to-open -bool true

    # Enable icon bounce
    defaults write com.apple.dock no-bouncing -bool false

    # Dock app icons
    # TODO

    # Dock other items
    # TODO
  fi

  ### Finishing touches
  print_step "Dock — DONE!"
}

handle_dock_dotfiles $1

unset -f handle_dock_dotfiles