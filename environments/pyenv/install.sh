#!/bin/sh
##
## Script to install Python, Pyenv and its configs
##

handle_pyenv_dotfiles() {

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
  print_step "Python & Pyenv"

  if test "$dry_run" -eq 0; then
    ### Make sure Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
      printf "Please make sure Homebrew is installed before installing Python/Pyenv\n"
      exit 1
    fi

    ### Make sure Python 2.7 is installed & up to date
    if brew ls --versions python@2 >/dev/null 2>&1; then
      print_substep "Checking for Python 2 updates..."
      # if brew upgrade python@2 2>/dev/null; then
      #   print_substep "Update complete!"
      # else
      #   print_substep "Python 2 is already up to date!"
      # fi
    else
      print_substep "Installing Python 2..."
      # brew install python@2
    fi

    ### Make sure Pyenv is installed & up to date
    if brew ls --versions pyenv >/dev/null 2>&1; then
      print_substep "Trying to update Pyenv..."
      # if brew upgrade pyenv 2>/dev/null; then
      #   print_substep "Update complete!"
      # else
      #   print_substep "Pyenv is already up to date!"
      # fi
    else
      print_substep "Installing Pyenv..."
      # brew install pyenv
    fi


    print_substep "Configuring Pyenv"
    ### Make Python 2 the default
    # pyenv global system

    # pyenv rehash

    ### Load user-specific definitions
    # local user_definitions="$base_dir/extra/{**,}/*pyenv{_install,}_local"
    # if ! command -v source_files_in >/dev/null 2>&1; then
    #   source "$base_dir/bin/source_files_in.sh"
    #   source_files_in $user_definitions
    #   unset source_files_in
    # else
    #   source_files_in $user_definitions
    # fi
  fi
  
  ### Finishing touches
  print_step "Python & Pyenv — DONE!"
}

handle_pyenv_dotfiles $1

unset -f handle_pyenv_dotfiles
