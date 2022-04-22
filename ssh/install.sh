#!/bin/sh
##
## Script to import previously created SSH keys and set SSH configurations
##

handle_ssh() {

  local dry_run=$2

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.."; pwd)"
  fi
  local ssh_dir="$base_dir/ssh"
  
  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: SSH" $1
  
  if test "$dry_run" -eq 0; then
    print_substep "NOT DRY RUN"
    # ### Symlink config file
    # symlink_files "$ssh_dir/config" "$HOME/.ssh" "" false
    
    # # Check if ssh-agent is running
    # # TODO
    
    # ### Handle keys, if available
    # for key_path in "caminho para as chaves"; do
    #   # Symlink private key to the .ssh folder
    #   symlink_files "$key_path" "$HOME/.ssh" "" false
      
    #   # TODO check if key is not public
    #   if test "cenas"; then
    #     # Add key to the ssh-agent
    #     # TODO check if mac
    #     if test "cenas"; then
    #       ssh-add -K "$HOME/.ssh/$(basename "$key_path")"
    #     else
    #       ssh-add "$HOME/.ssh/$(basename "$key_path")"
    #     fi
    #   fi
    # done
  fi
  
  ### Finishing touches
  print_header_footer "Step: SSH — DONE!"
}

handle_ssh $1 $2

unset -f handle_ssh