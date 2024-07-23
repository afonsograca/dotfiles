#!/bin/zsh
##
## Script to setup Notifications & Focus' configurations
##

handle_notifications_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Notifications & Focus"

  if test "$dry_run" -eq 0; then
    # Show Crash Reports as notifications
    defaults write com.apple.CrashReporter UseUNC -int 1

    # Hide notifications when display is sleeping, locked
    # mirroring or sharing
    defaults write com.apple.ncprefs.plist dnd_prefs -data 62706C6973743030D5010203040506060806085B646E644D6972726F7265645F100F646E64446973706C6179536C6565705F101E72657065617465644661636574696D6543616C6C73427265616B73444E445E646E64446973706C61794C6F636B5F10136661636574696D6543616E427265616B444E44090908090808131F3152617778797A7B0000000000000101000000000000000B0000000000000000000000000000007C
  fi

  ### Finishing touches
  print_step "Notifications & Focus — DONE!"
}

handle_notifications_dotfiles $1

unset -f handle_notifications_dotfiles