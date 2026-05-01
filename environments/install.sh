#!/bin/szh
##
## Script to setup all Environments
##
trap 'kill $(jobs -p)' EXIT

handle_environments_dotfiles() {
  if test -z "${base_dir+empty}"; then
    local base_dir="$(
      cd ..
      pwd
    )"
  fi

  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  ### Intro
  print_header_footer "Step: Environments" $1

  environments=(
    "ruby"
    "node"
    "python"
    "swift"
    "elixir"
  )
  for index in {1..$#environments}; do
    (
      cd ${environments[index]}
      zsh install.sh
    )
  done

  ### Finishing touches
  print_header_footer "Step: Environments — DONE!"
}

handle_environments_dotfiles $1 $2

unset -f handle_environments_dotfiles

trap - EXIT
