#!/bin/zsh
##
## Script to setup all Apps configurations
##

handle_app_dotfiles() {
  local dry_run=$2
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.."; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: Apps" $1

  packages=(
    # "maccy"
    "terminal"
    # "vscode"
    # "xcode"
  )
  for package in $packages; do

    (cd $base_dir/apps/$package; zsh config.sh $dry_run)
  done

  ### Finishing touches
  print_header_footer "Step: Apps — DONE!"
}

handle_app_dotfiles $1 $2

unset -f handle_app_dotfiles