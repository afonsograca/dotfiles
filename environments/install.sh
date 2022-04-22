#!/bin/sh
##
## Script to setup all Environments
##

handle_environments_dotfiles() {
  local dry_run=$2

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.."; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: Environments" $1

  environments=(
  "chruby"
  "nvm"
  "pyenv"
  "swiftenv"
)
for index in {1..$#environments}; do
  source "$base_dir/environments/${environments[index]}/install.sh" $dry_run
done

  ### Finishing touches
  print_header_footer "Step: Environments — DONE!"
}

handle_environments_dotfiles $1 $2

unset -f handle_environments_dotfiles