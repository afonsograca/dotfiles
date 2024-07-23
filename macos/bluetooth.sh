#!/bin/zsh
##
## Script to setup Bluetooth's configurations
##

handle_bluetooth_dotfiles() {
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
  print_step "Bluetooth"

  if test "$dry_run" -eq 0; then

    activate_sudo

    # TODO not working on Monterey
    # Turn on AAC codec for audio
    sudo defaults write bluetoothaudiod "Enable AAC codec" -int 1
    sudo defaults write bluetoothaudiod "AAC Bitrate" -int 256

    # Increase sound quality for Bluetooth headphones/headsets
    sudo defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" -int 80
    sudo defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 80
    sudo defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" -int 80
    sudo defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" -int 80
    sudo defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" -int 80
    sudo defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" -int 80
  fi

  ### Finishing touches
  print_step "Bluetooth — DONE!"
}

handle_bluetooth_dotfiles $1

unset -f handle_bluetooth_dotfiles