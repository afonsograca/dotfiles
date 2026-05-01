#!/bin/zsh
##
## Script to setup environments
##
trap 'kill $(jobs -p)' EXIT

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_environments_dotfiles() {
  ### Intro
  print_header_footer "Step: Environments" $1

  (
    cd "$DOTFILES_PATH/environments/ruby"
    zsh install.sh $2
  )

  ### Finishing touches
  print_header_footer "Step: Environments — DONE!"
}

handle_environments_dotfiles $1 $2

unset -f handle_environments_dotfiles

trap - EXIT
