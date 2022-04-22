#!/bin/sh
##
## Script to install NVM and packages
##

handle_nvm_dotfiles() {

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
  print_step "Node & NVM"

  if test "$dry_run" -eq 0; then
    ### Make sure Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
      printf "Please make sure Homebrew is installed before installing Node/NVM\n"
      exit 1
    fi

    ### Make sure Node is installed & up to date
    if brew ls --versions node >/dev/null 2>&1; then
      print_substep "Trying to update Node..."
      # if brew upgrade node 2>/dev/null; then
      #   print_substep "Update complete!"
      # else
      #   print_substep "Node is already up to date!"
      # fi
    else
      print_substep "Installing Node..."
      # brew install node
    fi


    ### Make sure NVM is installed & up to date
    if test ! -r "$NVM_DIR/nvm.sh"; then
      print_substep "Installing NVM..."
      
      # git clone "https://github.com/creationix/nvm.git" "$HOME/.nvm"
      # latest_version="$(cd $HOME/.nvm; git describe --abbrev=0 --tags --match "v[0-9]*" origin 2>/dev/null)"
      # if test $?; then
      #   $(cd $HOME/.nvm; git -c advice.detachedHead=false checkout "$latest_version")
      # fi
    else
      print_substep "Checking for NVM updates..."
      # $(cd "$HOME/.nvm"; git fetch origin)
      
      # current_version="$(cd $HOME/.nvm; git describe --abbrev=0 --tags 2>/dev/null)"
      # latest_version="$(cd $HOME/.nvm; git describe --abbrev=0 --tags --match "v[0-9]*" origin 2>/dev/null)"
      
      # if test "$current_version" = "$latest_version" || test -z "$latest_version"; then
      #   print_substep "Everything is up to date!"
      # else
      #   print_substep "Updating NVM..."
      #   $(cd $HOME/.nvm; git -c advice.detachedHead=false checkout $latest_version)
      # fi
    fi

    # source "$NVM_DIR/nvm.sh"

    ### Symlink NVM's bash completion to bash completion
    # print_substep "Setting up NVM's bash completion"
    # ln -sfn "$NVM_DIR/bash_completion" "$(brew --prefix)/etc/bash_completion.d/nvm"


    ### Create default-packages.lock
    # local default_packages="$(cat "$base_dir/environments/nvm/default-packages" 2>/dev/null)"

    # for file in "$base_dir"/extra/{**,}/*default-packages_local; do
    #   default_packages="${default_packages}\n\n$(cat "$file" 2>/dev/null)"
    # done
    # unset file

    # echo "$default_packages" > "$base_dir/default-packages.lock"


    ### Symlink default-packages.lock
    # if ! command -v symlink_files >/dev/null 2>&1; then
    #   source "$base_dir/bin/symlink_dotfiles.sh"
    # fi

    # symlink_files "$base_dir/default-packages.lock" "$NVM_DIR" "default-packages" false

    # print_substep "Configuring NVM"
    # ### Make system Node the default
    # nvm alias default system


    ### Load user-specific definitions
    # local user_definitions="$base_dir/extra/{**,}/*nvm{_install,}_local"
    # if ! command -v source_files_in >/dev/null 2>&1; then
    #   source "$base_dir/bin/source_files_in.sh"
    #   source_files_in $user_definitions
    #   unset source_files_in
    # else
    #   source_files_in $user_definitions
    # fi
  fi
  
  ### Finishing touches
  print_step "Node & NVM — DONE!"
}

handle_nvm_dotfiles $1

unset -f handle_nvm_dotfiles
