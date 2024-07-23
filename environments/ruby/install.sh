#!/bin/sh
##
## Script to install Ruby and its configs
##
trap 'kill $(jobs -p)' EXIT

handle_ruby_dotfiles() {

  local dry_run=$1

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ../..; pwd)"
  fi
    
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  ### Intro
  print_step "Ruby & Gems"

  if test "$dry_run" -eq 0; then
    ### Setup Ruby
    if ! command -v install_asdf_tool >/dev/null 2>&1; then
      source "$base_dir/environments/asdf/install_tool.sh"
    fi
    install_asdf_tool ruby
    unset -f install_asdf_tool

    ### Setup RubyGems
    (cd $base_dir/packages/rubygems; sh install.sh $dry_run)
  fi
  
  ### Finishing touches
  print_step "Ruby & Gems — DONE!"
}

handle_ruby_dotfiles $1

unset -f handle_ruby_dotfiles

trap - EXIT
