#!/bin/sh
##
## Script to import previously created GnuPG keys and set GnuPG configurations
##

handle_gpg() {

  local dry_run=$2

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.."; pwd)"
  fi
  local gpg_dir="$base_dir/gpg"
  
  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: GPG" $1
  
  if test "$dry_run" -eq 0; then
    ### Symlink config file
    symlink_files "$gpg_dir/config" "$HOME/.gnupg" "gpg.conf" false

    ### Symlink agent config file
    symlink_files "$gpg_dir/agent" "$HOME/.gnupg" "gpg-agent.conf" false

    ### Symlink SSHControl file
    local sshcontrol="$base_dir/extra/gpg/sshcontrol"
    if [ -s "$sshcontrol" ]; then
      symlink_files "$gpg_dir/config" "$HOME/.gnupg" "gpg-agent.conf" false
    fi

    ### Import keys
    for file in "$base_dir"/extra/gpg/*.gpg; do
      if [ -s "$file" ]; then
        gpg --import $file > /dev/null
      fi
    done
  fi
  
  ### Finishing touches
  print_header_footer "Step: GPG — DONE!"
}

handle_gpg $1 $2

unset -f handle_gpg