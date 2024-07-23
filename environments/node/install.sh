#!/bin/sh
##
## Script to install Node and packages
##
trap '' TERM

handle_node_dotfiles() {

  local dry_run=$1

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ../..; pwd)"
  fi
  local build_dir="$base_dir/build/node"
  mkdir -p $build_dir
    
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi

  ### Intro
  print_step "Node"

  if test "$dry_run" -eq 0; then
    ### Create build Default Packages
    local packages="$(cat "default-packages" 2>/dev/null)"

    for file in $base_dir/extra/{**/,}*default-packages*; do
      local packages="${packages}\n\n$(cat "$file" 2>/dev/null)"
    done
    unset file

    echo "$packages" > "$build_dir/default-npm-packages"


    ### Symlink Gemfile
    symlink_files "$build_dir/default-npm-packages" "$HOME" ""

    ### Setup Node
    if ! command -v install_asdf_tool >/dev/null 2>&1; then
      source "$base_dir/environments/asdf/install_tool.sh"
    fi
    install_asdf_tool nodejs
    unset -f install_asdf_tool

    ### Enable Corepack
    corepack enable

    if ! command -v pnpm >/dev/null 2>&1; then
      asdf reshim nodejs
    fi
  fi
  
  ### Finishing touches
  print_step "Node — DONE!"
}

handle_node_dotfiles $1

unset -f handle_node_dotfiles

trap - TERM
