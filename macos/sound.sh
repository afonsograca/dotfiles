#!/bin/zsh
##
## Script to setup Sound's configurations
##

handle_sound_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Sound"

  if test "$dry_run" -eq 0; then
    # Select Alert Sound
    defaults write NSGlobalDomain com.apple.sound.beep.sound "/System/Library/Sounds/Tink.aiff"

    # Play sound effects through output device
    defaults -currentHost write com.apple.soundpref AlertsUseMainDevice -int 1

    # Alert Volume
    defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0.75

    # Play sound on startup
    # TODO

    # Play user interface sound effects
    defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 1

    # Play feedback when volume is changed
    defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 1
  fi

  ### Finishing touches
  print_step "Sound — DONE!"
}

handle_sound_dotfiles $1

unset -f handle_sound_dotfiles