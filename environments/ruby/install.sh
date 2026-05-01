#!/bin/zsh
##
## Script to install Ruby and its configs
##
trap 'kill $(jobs -p)' EXIT

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_ruby_dotfiles() {
  local dry_run=$1

  ### Intro
  print_step "Ruby & Gems"

  if test "$dry_run" -eq 0; then
    ### Setup Ruby via mise
    if ! command -v install_with_mise >/dev/null 2>&1; then
      . "$DOTFILES_PATH/environments/mise/install_tool.sh"
    fi
    install_with_mise ruby
    unset -f install_with_mise

    ### Setup RubyGems
    (cd "$DOTFILES_PATH/packages/rubygems"; sh install.sh "$dry_run")
  fi

  ### Finishing touches
  print_step "Ruby & Gems — DONE!"
}

handle_ruby_dotfiles $1

unset -f handle_ruby_dotfiles

trap - EXIT
