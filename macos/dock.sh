#!/bin/sh
##
## Script to setup Dock configurations
##

handle_dock_dotfiles() {
  local dry_run=$1
  
  ### Intro
  print_step "Dock"

  if test "$dry_run" -eq 0; then
    print_substep "NOT DRY RUN"
  fi

  ### Finishing touches
  print_step "Dock — DONE!"
}

handle_dock_dotfiles $1

unset -f handle_dock_dotfiles