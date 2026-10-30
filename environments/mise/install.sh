#!/bin/zsh
##
## Script to install the global mise tools and their config
##

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_mise_dotfiles() {
  local dry_run=$1

  ### Intro
  print_step "mise"

  if test "$dry_run" -eq 0; then
    if ! command -v mise >/dev/null 2>&1; then
      print_substep "Please make sure mise is installed before installing its tools"
      exit 1
    fi

    symlink_files "$DOTFILES_PATH/environments/mise/config.toml" "$HOME/.config/mise" "" false

    print_substep "Installing tools..."
    mise install --yes
  fi

  ### Finishing touches
  print_step "mise — DONE!"
}

handle_mise_dotfiles $1

unset -f handle_mise_dotfiles
