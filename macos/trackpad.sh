#!/bin/sh
##
## Script to setup Trackpad's configurations
##

handle_macos_trackpad_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Trackpad"

  if test "$dry_run" -eq 0; then
    # Look up & data detectors
    defaults write NSGlobalDomain com.apple.trackpad.forceClick -int 1
    defaults write NSGlobalDomain com.apple.trackpad.threeFingerTapGesture -int 2

    # Secondary Click
    defaults write NSGlobalDomain ContextMenuGesture -int 1
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.enableSecondaryClick" -int 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -int 1

    # Tap to Click
    defaults -currentHost write NSGlobalDomain "com.apple.mouse.tapBehavior" -int 1
    defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1

    # Click
    defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
    defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0

    # Tracking speed
    defaults write NSGlobalDomain com.apple.trackpad.scaling -int 3

    # Silent clicking
    defaults write com.apple.AppleMultitouchTrackpad ActuationStrength -int 0

    # Force Click and haptic feedback
    defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 1
    defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -int 0

    # Scroll direction: Natural
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

    # Zoom in or out
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.pinchGesture" -int 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -int 1

    # Smart Zoom
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.twoFingerDoubleTapGesture" -int 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -int 1

    # Turn on Rotate
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.rotateGesture" -int 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -int 1
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -int 1

    # Swipe between pages
    defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -int 1

    # Swipe between full-screen apps
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.threeFingerHorizSwipeGesture" -int 2
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.fourFingerHorizSwipeGesture" -int 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 2
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2

    # Notification Centre
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture" -int 3
    defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

    # Mission Control
    defaults write com.apple.dock showMissionControlGestureEnabled -int 1

    # App Expose
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.threeFingerVertSwipeGesture" -int 2
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.fourFingerVertSwipeGesture" -int 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 2
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2
    defaults write com.apple.dock showAppExposeGestureEnabled -int 1

    # Launchpad
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.fourFingerPinchSwipeGesture" -int 2
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.fiveFingerPinchSwipeGesture" -int 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2
    defaults write com.apple.dock showLaunchpadGestureEnabled -int 1

    # Show Desktop
    defaults write com.apple.dock showDesktopGestureEnabled -int 1
  fi

  ### Finishing touches
  print_step "Trackpad — DONE!"
}

handle_macos_trackpad_dotfiles $1

unset -f handle_macos_trackpad_dotfiles