#!/bin/zsh
##
## Script to setup environments
##
trap 'kill $(jobs -p)' EXIT

handle_environments_dotfiles() {
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.." && pwd)"
  fi

  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  ### Intro
  print_header_footer "Step: Environments" $1

  (
    cd "$base_dir/environments/ruby"
    zsh install.sh $2
  )

  ### Finishing touches
  print_header_footer "Step: Environments — DONE!"
}

handle_environments_dotfiles $1 $2

unset -f handle_environments_dotfiles

trap - EXIT
