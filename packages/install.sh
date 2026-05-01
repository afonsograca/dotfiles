#!/bin/sh
##
## Script to setup all Packages
##
trap 'kill $(jobs -p)' EXIT

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_packages_dotfiles() {
  local dry_run=$2

  ### Intro
  print_header_footer "Step: Packages" $1

  packages=(
    "homebrew"
  )
  for index in {1..$#packages}; do
    (cd "$DOTFILES_PATH/packages/${packages[index]}"; sh install.sh $dry_run)
  done

  ### Finishing touches
  print_header_footer "Step: Packages — DONE!"
}

handle_packages_dotfiles $1 $2

unset -f handle_packages_dotfiles

trap - EXIT
