#!/bin/sh
##
## Script to install Rubygems, Bundler and its configs
##

handle_rubygems_dotfiles() {

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
  print_step "RubyGems & Bundler"

  if test "$dry_run" -eq 0; then

    # ### Make sure RubyGems is installed
    # if ! command -v gem >/dev/null 2>&1; then
    #   printf "Please make sure RubyGems is installed before installing Bundler and Gems"
    #   exit 1
    # fi

    # ### Make sure you're not using system's RubyGems
    # if test "command -v brew" = "/usr/bin/gem"; then
    #   printf "Please make sure you're not using the system's RubyGems"
    #   exit 1
    # fi


    ### Make sure RubyGems is updated
    print_substep "Checking for RubyGems updates..."
    # gem update --system


    ### Make sure Bundler is installed
    if ! command -v bundle >/dev/null 2>&1; then
      print_substep "Installing Bundler..."
      # gem install bundler --no-document
    fi


    # ### Create Gemfile.lock
    # gemfile="$(cat "$base_dir/packages/rubygems/Gemfile" 2>/dev/null)"

    # for file in "$base_dir"/extra/{**,}/*Gemfile_local; do
    #   gemfile="${gemfile}\n\n$(cat "$file" 2>/dev/null)"
    # done
    # unset file

    # echo "$gemfile" > "$base_dir/packages/rubygems/Gemfile.lock"


    # ### Symlink Brewfile.lock
    # if ! command -v symlink_files >/dev/null 2>&1; then
    #   source "$base_dir/bin/symlink_dotfiles.sh"
    # fi

    # symlink_files "$base_dir/packages/rubygems/Gemfile.lock" "$HOME/.gem" "Gemfile" false

    # unset gemfile


    ### Install and update all your gems
    print_substep "Trying to install/update your gems..."
    # (cd "$HOME/.gem"; bundle update)


    ### Remove outdated gem versions
    print_substep "Cleaning up old gems..."
    # gem cleanup
  fi
  
  ### Finishing touches
  print_step "RubyGems & Bundler — DONE!"
}

handle_rubygems_dotfiles $1

unset -f handle_rubygems_dotfiles
