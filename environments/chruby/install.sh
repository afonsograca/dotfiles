#!/bin/sh
##
## Script to install Ruby, Chruby, its configs
##

handle_chruby_dotfiles() {

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
  print_step "Ruby, Chruby & Gems"

  if test "$dry_run" -eq 0; then

    ### Make sure Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
      printf "Please make sure Homebrew is installed before installing Ruby/Chruby\n"
      exit 1
    fi

    ### Make sure Ruby is installed & up to date
    if brew ls --versions ruby >/dev/null 2>&1; then
      print_substep "Checking for Ruby updates..."
      # if brew upgrade ruby 2>/dev/null; then
      #   print_substep "Update complete!"
      # else
      #   print_substep "Ruby is already up to date!"
      # fi
    else
      print_substep "Installing Ruby..."
      # brew install ruby
    fi


    ### Make sure Chruby is installed & up to date
    if brew ls --versions chruby >/dev/null 2>&1; then
      print_substep "Checking for Chruby updates..."
      # if brew upgrade chruby 2>/dev/null; then
      #   print_substep "Update complete!"
      # else
      #   print_substep "Chruby is already up to date!"
      # fi
    else
      print_substep "Installing Chruby..."
      # brew install chruby
    fi


    print_substep "Configuring Chruby"
    
    ### Make Brew's ruby the default
    # TODO check if bash is loaded, if not, load RUBIES and symlink ruby to ~/.ruby-version
    # if test -r "$(brew --prefix)/share/chruby/chruby.sh"; then
    #   source "$(brew --prefix)/share/chruby/chruby.sh"
    #   RUBIES+=(
    #     "$(brew --prefix)/Cellar/ruby/"*
    #     "$(brew --prefix)/opt/ruby/"
    #     )
    #   source "$(brew --prefix)/share/chruby/auto.sh"
    # fi

    ### Load user-specific definitions
    # local user_definitions="$base_dir/extra/{**,}/*chruby{_install,}_local"
    # if ! command -v source_files_in >/dev/null 2>&1; then
    #   source "$base_dir/bin/source_files_in.sh"
    #   source_files_in $user_definitions
    #   unset source_files_in
    # else
    #   source_files_in $user_definitions
    # fi
  fi
  
  ### Finishing touches
  print_step "Ruby, Chruby & Gems — DONE!"
}

handle_chruby_dotfiles $1

unset -f handle_chruby_dotfiles
