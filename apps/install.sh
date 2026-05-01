#!/bin/zsh
##
## Script to setup all Apps configurations
##

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_app_dotfiles() {
  local dry_run=$2

  ### Intro
  print_header_footer "Step: Apps" $1

  packages=(
    # "maccy"
    "terminal"
    # "vscode"
    # "xcode"
  )
  for package in $packages; do
    (cd $DOTFILES_PATH/apps/$package; zsh config.sh $dry_run)
  done

  ### Finishing touches
  print_header_footer "Step: Apps — DONE!"
}

handle_app_dotfiles $1 $2

unset -f handle_app_dotfiles
