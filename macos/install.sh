#!/bin/sh
##
## Script to setup all MacOS configurations
##

handle_macos_dotfiles() {
  local dry_run=$2
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: MacOS" $1

  # Prevent overrides by closing all System Prefs
  osascript -e 'tell application "System Preferences" to quit'

  components=(
    # "general"
    # "desktop"
    # "dock"
    # "menubar"  
    # "missioncontrol"
    # "siri"
    # "spotlight"
    # "languageregion"
    # "notifications"
    # "accessibility"
    # "screentime"
    # "securityprivacy"
    # "softwareupdate"
    # "network"
    # "bluetooth"
    # "sound"
    # "touchid"
    # "keyboard"
    # "trackpad"
    # "mouse"
    # "displays"
    # "battery"
    # "datetime"
    # "sharing"
    # "timemachine"
    # "sudo"
    "finder"
  )
  for component in $components; do
    (cd $base_dir/macos; zsh $component.sh $dry_run)
  done

  ### Finishing touches
  print_header_footer "Step: MacOS — DONE!"
  print_substep "(Note: some of these changes require a logout/restart to take effect.)"
}

handle_macos_dotfiles $1 $2

unset -f handle_macos_dotfiles