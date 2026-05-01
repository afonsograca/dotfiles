#!/bin/sh
##
## Script to import previously created GnuPG keys and set GnuPG configurations
##
trap '' TERM

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_gpg() {
  local dry_run=$2
  local build_dir="$DOTFILES_PATH/build/gpg"
  mkdir -p $build_dir

  ### Intro
  print_header_footer "Step: GPG" $1

  if test "$dry_run" -eq 0; then
    ### Symlink config file
    cp "config" "$build_dir/gpg.conf"
    symlink_files "$build_dir/gpg.conf" "$HOME/.gnupg" "" false

    ### Symlink agent config file
    local brew_prefix=$(brew --prefix)
    cp "agent" "$build_dir/gpg-agent.conf"
    sed -i '' "s|\$(brew --prefix)|$brew_prefix|g" "$build_dir/gpg-agent.conf"
    symlink_files "$build_dir/gpg-agent.conf" "$HOME/.gnupg" "" false

    ### Symlink SSHControl file
    local sshcontrol="$DOTFILES_PATH/extra/gpg/sshcontrol"
    if [ -s "$sshcontrol" ]; then
      cp "$sshcontrol" "$build_dir/sshcontrol"
      symlink_files "$sshcontrol" "$HOME/.gnupg" "" false
    fi

    ### Reload Agent
    gpgconf --kill gpg-agent

    ### Import keys
    for file in "$DOTFILES_PATH"/extra/gpg/*.gpg; do
      if [ -s "$file" ]; then
        gpg --import $file >/dev/null 2>&1
      fi
    done
  fi

  ### Finishing touches
  print_header_footer "Step: GPG — DONE!"
}

handle_gpg $1 $2

unset -f handle_gpg

trap - TERM
