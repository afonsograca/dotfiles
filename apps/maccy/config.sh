#!/bin/zsh
##
## Script to setup all Maccy's configurations
##

handle_vscode_dotfiles() {
  local dry_run=$1

  if test -z "${base_dir+empty}"; then
    local base_dir="$(
      cd ../..
      pwd
    )"
  fi
  local build_dir="$base_dir/build/maccy"
  mkdir -p $build_dir

  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi

  ### Intro
  print_step "Maccy"

  if test "$dry_run" -eq 0; then

    ### Open Maccy for the first time if folder doesn't exist
    print_substep "Make sure Maccy's file structure is in place..."
    if ! defaults read org.p0deje.Maccy >/dev/null 2>&1; then
      open -a Maccy
      pkill -x Maccy
    fi

    ### Set preferences
    print_substep "Setting Maccy's preferences..."

    # Set shortcut to open app
    defaults write org.p0deje.Maccy "KeyboardShortcuts_popup" "'{\\\"carbonModifiers\\\":768,\\\"carbonKeyCode\\\":9}'"

    # # Turn on Launch at Login
    ## TODO

    # Turn on Update automatically
    defaults write org.p0deje.Maccy SUAutomaticallyUpdate 1

    # Turn on Check for updates automatically
    defaults write org.p0deje.Maccy SUEnableAutomaticChecks 1

    # Turn on Fuzzy Search
    defaults write org.p0deje.Maccy fuzzySearch 1

    # Turn on Paste automatically
    defaults write org.p0deje.Maccy pasteByDefault 1

    # Set history size
    defaults write org.p0deje.Maccy historySize 9999

    # Set ignored apps
    defaults write org.p0deje.Maccy ignoredApps -array "com.agilebits.onepassword7" "com.apple.keychainaccess"

    ### Symlink database
    print_substep "Setting up database..."
    cp "$base_dir/extra"/**/maccy/*sqlite* "$HOME/Library/Containers/org.p0deje.Maccy/Data/Library/Application Support/Maccy/"

    symlink_files "$build_dir/*" "$HOME/Library/Containers/org.p0deje.Maccy/Data/Library/Application Support/Maccy" "" false
  fi

  ### Finishing touches
  print_step "Maccy — DONE!"
}

handle_vscode_dotfiles $1

unset -f handle_vscode_dotfiles
