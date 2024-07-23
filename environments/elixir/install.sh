#!/bin/sh
## 
## Script to install Elixir via asdf
##
trap '' TERM

handle_elixir_dotfiles() {

  local dry_run=$1

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/../.."; pwd)"
  fi
    
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  ### Intro
  print_step "Elixir"

  if test "$dry_run" -eq 0; then
    ### Setup Elixir
    if ! command -v install_asdf_tool >/dev/null 2>&1; then
      source "$base_dir/environments/asdf/install_tool.sh"
    fi
    install_asdf_tool elixir
    unset -f install_asdf_tool
  fi
  
  ### Finishing touches
  print_step "Elixir — DONE!"
}

handle_elixir_dotfiles $1

unset -f handle_elixir_dotfiles

trap - TERM
