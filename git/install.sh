#!/bin/zsh
##
## Script to deal with git
##
trap '' TERM

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_git_dotfiles() {
  local build_dir="$DOTFILES_PATH/build/git"
  mkdir -p $build_dir

  ### Intro
  print_header_footer "Step: Git" $1

  # if test "$DOTFILES_DRY_RUN" -eq 0; then
    ### Create build gitconfig
    local gitconfig="$(cat "gitconfig" 2>/dev/null)"

    if [[ -d "$DOTFILES_PATH/extra" ]]; then
      for file in "$DOTFILES_PATH"/extra/{**,}/*gitconfig_local(.N); do
        local gitconfig="${gitconfig}\n\n$(cat "$file" 2>/dev/null)"
      done
      unset file
    fi

    echo "$gitconfig" > "$build_dir/gitconfig"

    ### Symlink gitconfig
    symlink_files "$build_dir/gitconfig" "$HOME" ""

    ### Create build gitignore_global
    local gitignore="$(cat "gitignore_global" 2>/dev/null)"

    if [[ -d "$DOTFILES_PATH/extra" ]]; then
      for file in "$DOTFILES_PATH"/extra/{**,}/*gitignore_local(.N); do
        local gitignore="${gitignore}\n\n$(cat "$file" 2>/dev/null)"
      done
      unset file
    fi

    echo "$gitignore" > "$build_dir/gitignore_global"

    ### Symlink gitignore_global
    symlink_files "gitignore_global" "$HOME" ""
  # fi

  ### Finishing touches
  print_header_footer "Step: Git — DONE!"
}

handle_git_dotfiles $1 $2
unset -f handle_git_dotfiles

trap - TERM
