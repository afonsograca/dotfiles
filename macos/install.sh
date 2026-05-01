#!/bin/sh
##
## Script to setup all MacOS configurations
##

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_macos_dotfiles() {
  local dry_run=$2

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
    (cd $DOTFILES_PATH/macos; zsh $component.sh $dry_run)
  done

  ### Finishing touches
  print_header_footer "Step: MacOS — DONE!"
  print_substep "(Note: some of these changes require a logout/restart to take effect.)"
}

handle_macos_dotfiles $1 $2

unset -f handle_macos_dotfiles
