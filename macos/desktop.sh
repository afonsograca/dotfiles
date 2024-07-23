#!/bin/zsh
##
## Script to setup Desktop & Screensaver configurations
##

handle_desktop_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  local extra_dir="$base_dir/extra"
  mkdir -p $extra_dir
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi

  if ! command -v activate_sudo >/dev/null 2>&1; then
    source "$base_dir/bin/sudo.sh"
  fi
  
  ### Intro
  print_step "Desktop"

  if test "$dry_run" -eq 0; then
    # Make sure you have admin privileges
    activate_sudo

    # Set wallpaper
    if test -s $extra_dir/**/wallpaper.{jpg,png}(.N); then
      local wallpapers=( $extra_dir/**/wallpaper.{jpg,png}(.N) )
      osascript -e 'tell application "System Events" to tell every desktop to set picture to "'"${wallpapers[1]}"'"'
    fi

    # Set screensaver timer
    defaults -currentHost write com.apple.screensaver idleTime -int 300

    # Set screensaver
    defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName Monterey path "/System/Library/Screen Savers/Monterey.saver" type 0

  fi

  ### Finishing touches
  print_step "Desktop — DONE!"
}

handle_desktop_dotfiles $1

unset -f handle_desktop_dotfiles