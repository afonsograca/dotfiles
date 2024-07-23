#!/bin/sh
##
## Script to setup all Packages
##
trap 'kill $(jobs -p)' EXIT

handle_packages_dotfiles() {
  local dry_run=$2
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: Packages" $1

  packages=(
    "homebrew"
  )
  for index in {1..$#packages}; do
    (cd "$base_dir/packages/${packages[index]}"; sh install.sh $dry_run)
  done

  ### Finishing touches
  print_header_footer "Step: Packages — DONE!"
}

handle_packages_dotfiles $1 $2

unset -f handle_packages_dotfiles

trap - EXIT
