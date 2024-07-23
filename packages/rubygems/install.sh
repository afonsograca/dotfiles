#!/bin/sh
##
## Script to install Rubygems, Bundler and its configs
##
trap '' TERM

handle_rubygems_dotfiles() {

  local dry_run=$1

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ../..; pwd)"
  fi
  local build_dir="$base_dir/build/ruby"
  mkdir -p $build_dir
    
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi

  ### Intro
  print_step "RubyGems & Bundler"

  if test "$dry_run" -eq 0; then

    ### Make sure RubyGems is installed
    if ! command -v gem >/dev/null 2>&1; then
      printf "Please make sure RubyGems is installed before installing Bundler and Gems"
      exit 1
    fi

    ### Make sure you're not using system's RubyGems
    if test "command -v gem" = "/usr/bin/gem"; then
      printf "Please make sure you're not using the system's RubyGems"
      exit 1
    fi


    ### Make sure RubyGems is updated
    print_substep "Checking for RubyGems updates..."
    gem update --system


    ### Make sure Bundler is installed
    if ! command -v bundle >/dev/null 2>&1; then
      print_substep "Installing Bundler..."
      gem install bundler --no-document
    fi


    ### Create build Gemfile
    local gemfile="$(cat "Gemfile" 2>/dev/null)"

    for file in $base_dir/extra/{**,}/*Gemfile*; do
      local gemfile="${gemfile}\n\n$(cat "$file" 2>/dev/null)"
    done
    unset file

    echo "$gemfile" > "$build_dir/Gemfile"


    ### Symlink Gemfile
    symlink_files "$build_dir/Gemfile" "$HOME/.gem" "" false

    ### Install and update all your gems
    print_substep "Trying to install/update your gems..."
    (cd "$HOME/.gem"; bundle update --quiet)


    ### Remove outdated gem versions
    print_substep "Cleaning up old gems..."
    gem cleanup --silent
  fi
  
  ### Finishing touches
  print_step "RubyGems & Bundler — DONE!"
}

handle_rubygems_dotfiles $1

unset -f handle_rubygems_dotfiles

trap - TERM
