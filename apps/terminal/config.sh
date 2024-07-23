#!/bin/sh
##
## Script to set Terminal's settings
##

handle_terminal_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ../..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Terminal"

  if test "$dry_run" -eq 0; then
    # Check if there is a user-defined theme to load otherwise load "Glip Glops"
    local terminal_theme="Glip Glops"
    if test -n "$local_terminal_theme"; then
      local terminal_theme="$local_terminal_theme"
    fi

    # Enable Secure Keyboard Entry
    defaults write com.apple.terminal SecureKeyboardEntry -bool true

    ### View

    # Hide Marks
    defaults write com.apple.Terminal ShowLineMarks -int 0

    ### General

    # On startup, set new window with profile Dracula
    defaults write com.apple.terminal "Startup Window Settings" -string "$terminal_theme"

    ### Profiles

    # Set the default window settings to Dracula
    defaults write com.apple.terminal "Default Window Settings" -string "$terminal_theme"

    ## Advanced

    # Disable Audible bell
    defaults write com.apple.terminal Bell -bool false

    # Enable Visual bell always
    defaults write com.apple.terminal VisualBell -bool true
    defaults write com.apple.terminal VisualBellOnlyWhenMuted -bool false

    # Set Text encoding to UTF-8
    defaults write com.apple.terminal StringEncodings -array 4
  fi

  ### Finishing touches
  print_step "Terminal — DONE!"
}

handle_terminal_dotfiles $1

unset -f handle_terminal_dotfiles
