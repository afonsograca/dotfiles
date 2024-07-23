#!/bin/zsh
##
## Script to setup Display's configurations
##

handle_display_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Display"

  if test "$dry_run" -eq 0; then

    # TODO
    # Turn night shift on from sunset to sunrise
    # osascript -e 'tell application "System Preferences"
    #     launch
    #     reveal pane id "com.apple.preference.displays"
    #   end tell
    #   tell application "System Events" to tell window "Displays" of process "System Preferences"
    #     repeat until button "Night Shift…" exists
    #       delay 0.1
    #     end repeat
    #     click button "Night Shift…"
    #     repeat until sheet 1 exists
    #       delay 0.1
    #     end repeat
    #     tell pop up button 1 of sheet 1
    #       click
    #       repeat until menu item "Sunset to Sunrise" of menu 1 exists
    #         delay 0.1
    #       end repeat
    #       click menu item "Sunset to Sunrise" of menu 1
    #     end tell
    #     repeat until not (menu 1 of pop up button 1 of sheet 1 exists)
    #       delay 0.1
    #     end repeat
    #     click button "Done" of sheet 1
    #     repeat until not (sheet 1 exists)
    #       delay 0.1
    #     end repeat
    #   end tell
    #   tell application "System Preferences" to quit'
  fi

  ### Finishing touches
  print_step "Display — DONE!"
}

handle_display_dotfiles $1

unset -f handle_display_dotfiles