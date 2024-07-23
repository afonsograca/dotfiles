#!/bin/sh
##
## Script to setup Battery's configurations
##

handle_battery_dotfiles() {
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
  print_step "Battery"

  if test "$dry_run" -eq 0; then

    activate_sudo

    # Turn display off after while on battery
    sudo pmset -b displaysleep 2

    # Put hard disks to sleep when possible while on battery
    sudo pmset -b disksleep 2

    # Slightly dim the display while on battery power
    sudo pmset -b lessbright 1

    # Optimise video streaming while on battery
    # TODO

    # Optimised battery charging
    # TODO

    # Low power mode while on battery
    sudo pmset -b lowpowermode 0

    # Play chime when computer connects to power
    defaults write com.apple.PowerChime ChimeOnAllHardware -bool true

    # Turn display off after while on power adapter
    sudo pmset -c displaysleep 10

    # Prevent computer from sleeping automatically when the display is off
    sudo pmset -c sleep 0

    # Put hard disks to sleep when possible while on power source
    sudo pmset -c disksleep 10

    # Wake for network access
    sudo pmset -c womp 1

    # Low power mode while on power source
    sudo pmset -c lowpowermode 0
  fi

  ### Finishing touches
  print_step "Battery — DONE!"
}

handle_battery_dotfiles $1

unset -f handle_battery_dotfiles