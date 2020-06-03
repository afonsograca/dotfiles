#!/bin/sh
##
## Script to deal with all system files 
##

handle_inputrc() {
  local base_dir="$1"
  local system_dir="$2"

  print_step "Setting Readline"
  ### Create inputrc.lock
  local inputrc="$(cat "$system_dir/inputrc" 2>/dev/null)"

  for file in "$base_dir"/extra/{**,}/inputrc_local; do
    local inputrc="${inputrc}\n\n$(cat "$file" 2>/dev/null)"
  done
  unset file

  printf "$inputrc" > "$system_dir/inputrc.lock"

  ### Symlink inputrc
  symlink_files "$system_dir/inputrc.lock" "$HOME" "inputrc"
}

handle_system_dotfiles() {
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.."; pwd)"
  fi
  local system_dir="$base_dir/system"
  
  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: System" $1

  ### Set zsh as the default shell
  print_step "Setting the Shell type"
  chsh -s /bin/zsh
  
  ### Symlink bash_profile & bashrc
  print_step "Setting Configuration"
  local filenames="bash_profile bashrc"
  for filename in $filenames; do
    symlink_files "$system_dir/bash_profile" "$HOME"
  done
  
  ### Symlink inputrc
  handle_inputrc "$base_dir" "$system_dir"

  ### Finishing touches
  print_header_footer "Step: System — DONE!"
}

handle_system_dotfiles "$1"

unset -f handle_system_dotfiles
unset -f handle_inputrc
