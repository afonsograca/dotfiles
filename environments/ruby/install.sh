#!/bin/zsh
##
## Script to install Ruby and its configs
##
trap 'kill $(jobs -p)' EXIT

handle_ruby_dotfiles() {

  local dry_run=$1

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/../.."; pwd)"
  fi

  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  ### Intro
  print_step "Ruby & Gems"

  if test "$dry_run" -eq 0; then
    ### Setup Ruby via mise
    if ! command -v install_with_mise >/dev/null 2>&1; then
      source "$base_dir/environments/mise/install_tool.sh"
    fi
    install_with_mise ruby
    unset -f install_with_mise

    ### Setup RubyGems
    (cd "$base_dir/packages/rubygems"; sh install.sh "$dry_run")
  fi

  ### Finishing touches
  print_step "Ruby & Gems — DONE!"
}

handle_ruby_dotfiles $1

unset -f handle_ruby_dotfiles

trap - EXIT
