#!/bin/sh
##
## Script to install Swiftenv its configs
##

handle_swiftenv_dotfiles() {

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
  print_step "Swiftenv"

  if test "$dry_run" -eq 0; then
    ### Make sure Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
      printf "Please make sure Homebrew is installed before installing Swiftenv\n"
      exit 1
    fi


    ### Make sure Swiftenv is installed & up to date
    if brew ls --versions swiftenv >/dev/null 2>&1; then
      print_substep "Checking for Swiftenv updates..."
      # if brew upgrade kylef/formulae/swiftenv 2>/dev/null; then
      #   echo "Update complete!"
      # else
      #   echo "Swiftenv is already up to date!"
      # fi
    else
      print_substep "Installing Swiftenv..."
      # brew install kylef/formulae/swiftenv
    fi
    echo ""


    print_substep "Configuring Swiftenv"
    ### Make system's Swift the default
    # swiftenv global system

    # swiftenv rehash

    ### Load user-specific definitions
    # local user_definitions="$base_dir/extra/{**,}/*swiftenv{_install,}_local"
    # if ! command -v source_files_in >/dev/null 2>&1; then
    #   source "$base_dir/bin/source_files_in.sh"
    #   source_files_in $user_definitions
    #   unset source_files_in
    # else
    #   source_files_in $user_definitions
    # fi
  fi
  
  ### Finishing touches
  print_step "Swiftenv — DONE!"
}

handle_swiftenv_dotfiles $1

unset -f handle_swiftenv_dotfiles
