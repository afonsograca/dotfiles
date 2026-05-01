#!/bin/sh
##
## Script to install & update Homebrew
##
trap '' TERM

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_homebrew_dotfiles() {
  local dry_run=$1
  local build_dir="$DOTFILES_PATH/build/homebrew"
  mkdir -p $build_dir

  if ! command -v activate_sudo >/dev/null 2>&1; then
    . "$DOTFILES_PATH/bin/sudo.sh"
  fi

  if ! command -v install_xcode_tools >/dev/null 2>&1; then
    . "$DOTFILES_PATH/bin/xcode-tools.sh"
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

    for file in $DOTFILES_PATH/extra/{**,}/*Brewfile*; do
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
