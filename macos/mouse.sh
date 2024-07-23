#!/bin/sh
##
## Script to setup Mouse's configurations
##

handle_macos_mouse_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Mouse"

  if test "$dry_run" -eq 0; then
    # Turn on Natural scroll
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

    # Turn on Secondary click
    defaults write com.apple.AppleMultitouchMouse MouseButtonMode TwoButton
    defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton

    # Turn on Smart Zoom
    defaults write com.apple.AppleMultitouchMouse MouseOneFingerDoubleTapGesture -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseOneFingerDoubleTapGesture -bool true

    # Set speed
    defaults write NSGlobalDomain com.apple.mouse.scaling -int 3

    # Turn on Swipe between pages
    defaults write NSGlobalDomain AppleEnableMouseSwipeNavigateWithScrolls -bool true

    # Turn on Swipe between full-screen apps
    defaults write com.apple.AppleMultitouchMouse MouseTwoFingerHorizSwipeGesture -int 2
    defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseTwoFingerHorizSwipeGesture -int 2

    # Turn on Mission Control 
    defaults write com.apple.AppleMultitouchMouse MouseTwoFingerDoubleTapGesture -int 3
    defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseTwoFingerDoubleTapGesture -int 3
  fi

  ### Finishing touches
  print_step "Mouse — DONE!"
}

handle_macos_mouse_dotfiles $1

unset -f handle_macos_mouse_dotfiles
