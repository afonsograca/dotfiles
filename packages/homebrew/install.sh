#!/bin/sh
##
## Script to install & update Homebrew
##
trap '' TERM

handle_homebrew_dotfiles() {

  local dry_run=$1

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ../..; pwd)"
  fi
  local build_dir="$base_dir/build/homebrew"
  mkdir -p $build_dir
    
  if ! command -v activate_sudo >/dev/null 2>&1; then
    source "$base_dir/bin/sudo.sh"
  fi
    
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
    
  if ! command -v install_xcode_tools >/dev/null 2>&1; then
    source "$base_dir/bin/xcode-tools.sh"
  fi

  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi

  ### Intro
  print_step "Homebrew"

  if test "$dry_run" -eq 0; then
    activate_sudo

    if ! install_xcode_tools; then
      return 1
    fi

    ### Make sure Brew is installed & up to date
    if ! command -v brew >/dev/null 2>&1; then
      print_substep "Installing brew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      print_substep "Updating brew..."
      brew update
    fi

    ### Create build Brewfile
    local brewfile="$(cat "Brewfile" 2>/dev/null)"

    for file in $base_dir/extra/{**,}/*Brewfile*; do
      local brewfile="${brewfile}\n\n$(cat "$file" 2>/dev/null)"
    done
    unset file

    echo "$brewfile" > "$build_dir/Brewfile"

    # ### Symlink Brewfile
    symlink_files "$build_dir/Brewfile" "$HOME" ""

    ### Install and update all your brews and casks
    print_substep "Installing/Updating taps/brews/casks/fonts..."
    if ! brew bundle check --global >/dev/null 2>&1; then
      brew bundle --global --quiet
    fi

    brew upgrade --quiet
    brew upgrade --cask --quiet 

    ### Remove outdated versions from the cellar.
    print_substep "Cleaning up old brews/taps..."
    brew cleanup --quiet
  fi
  
  ### Finishing touches
  print_step "Homebrew — DONE!"
}

handle_homebrew_dotfiles $1

unset -f handle_homebrew_dotfiles

trap - TERM
