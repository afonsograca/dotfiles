#!/bin/sh
##
## Script to install Yarn and its configs & packages
##

handle_yarn_dotfiles() {

  local dry_run=$1

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/../.."; pwd)"
  fi
    
  if ! command -v activate_sudo >/dev/null 2>&1; then
    source "$base_dir/bin/sudo.sh"
  fi
    
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
    
  if ! command -v install_xcode_tools >/dev/null 2>&1; then
    source "$base_dir/bin/xcode-tools.sh"
  fi

  ### Intro
  print_step "Yarn & Packages"

  if test "$dry_run" -eq 0; then
    ### Make sure yarn is installed
    if ! command -v yarn >/dev/null 2>&1; then
      ### Make sure Homebrew is installed
      if ! command -v brew >/dev/null 2>&1; then
        printf "Please make sure Homebrew is installed before installing Yarn\n"
        exit 1
      fi
      print_substep "Installing Yarn..."
      # brew install yarn
    fi

    # ### Symlink package.json
    # yarn_global_dir="$(yarn global dir)"
    # if ! command -v symlink_files >/dev/null 2>&1; then
    #   source "$base_dir/bin/symlink_dotfiles.sh"
    # fi

    # symlink_files "$base_dir/packages/yarn/package.json" "$yarn_global_dir" "package.json" false

    ### Install and update all your packages
    print_substep "Trying to install/update your packages..."
    # if ! yarn global upgrade 2>/dev/null; then
    #   (cd "$yarn_global_dir"; yarn install)
    # fi
  fi
  
  ### Finishing touches
  print_step "Yarn & Packages — DONE!"
}

handle_yarn_dotfiles $1

