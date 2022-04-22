#!/bin/sh
##
## Script to setup all Packages
##

handle_packages_dotfiles() {
  local dry_run=$2
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.."; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: Packages" $1

  packages=(
    "homebrew"
    "rubygems"
    "yarn"
  )
  for index in {1..$#packages}; do
    source "$base_dir/packages/${packages[index]}/install.sh" $dry_run
  done

  ### Finishing touches
  print_header_footer "Step: Packages — DONE!"
}

handle_packages_dotfiles $1 $2

unset -f handle_packages_dotfiles