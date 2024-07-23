#!/bin/sh
##
## Script to setup all Xcode's configurations
##

handle_xcode_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Xcode"

  if test "$dry_run" -eq 0; then

    ### General


    ### Accounts


    ### Behaviours


    ### Navigation


    ### Fonts & Colors


    ### Text Editing


    ### Key Bindings


    ### Source Control


    ### Components


    ### Locations


    ### Server & Bots


    ### Extra features

    Enable extra features on Simulator
    mkdir -p /AppleInternal

    Add the "ViewModel" and "View" counterpart suffixes
    defaults write com.apple.dt.Xcode "IDEAdditionalCounterpartSuffixes" -array-add "ViewModel" "View"
  fi

  ### Finishing touches
  print_step "Xcode — DONE!"
}

handle_xcode_dotfiles $1

unset -f handle_xcode_dotfiles