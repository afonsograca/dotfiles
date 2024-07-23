#!/bin/zsh
##
## Script to setup Language & Region's configurations
##

handle_language_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Language & Region"

  if test "$dry_run" -eq 0; then
    # Preferred languages
    defaults write NSGlobalDomain AppleLanguages -array "en-GB" "pt-PT" "en-PT"

    # Region
    defaults write NSGlobalDomain AppleLocale -string "en_PT"
  fi

  ### Finishing touches
  print_step "Language & Region — DONE!"
}

handle_language_dotfiles $1

unset -f handle_language_dotfiles