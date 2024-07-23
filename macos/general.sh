#!/bin/sh
##
## Script to setup General's configurations
##

handle_macos_general_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "General"

  if test "$dry_run" -eq 0; then

    # Set appearnace to Auto
    defaults delete NSGlobalDomain AppleInterfaceStyle >/dev/null 2>&1
    defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

    # Set accent color to Multicolour
    defaults delete NSGlobalDomain AppleAccentColor >/dev/null 2>&1

    # Set highlight color to Multicolour
    defaults delete NSGlobalDomain AppleHighlightColor >/dev/null 2>&1

    # Set sidebar icon size to medium
    defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

    # Enable wallpaper tinting
    defaults write NSGlobalDomain AppleReduceDesktopTinting -bool true

    # Always show scrollbars
    defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"

    # Enable Click to jump to place in scroll-bar
    defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

    # Default Browser
    # TODO
    # https://krypted.com/mac-os-x/programmatically-changing-the-mac-os-x-browser/
  
    # Prefer tabs when opening documents
    defaults write NSGlobalDomain AppleWindowTabbingMode -string "fullscreen"

    # Enable Ask to keep changes
    defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true

    # Enable Saving windows when quiting
    defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true

    # Enable Handoff
    defaults -currentHost write com.apple.coreservices.useractivityd ActivityAdvertisingAllowed -bool true
    defaults -currentHost write com.apple.coreservices.useractivityd ActivityReceivingAllowed -bool true
  fi

  ### Finishing touches
  print_step "General — DONE!"
}

handle_macos_general_dotfiles $1

unset -f handle_macos_general_dotfiles