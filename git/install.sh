#!/bin/zsh
##
## Script to deal with git 
##
trap '' TERM

handle_git_dotfiles() {
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  local build_dir="$base_dir/build/git"
  mkdir -p $build_dir
  
  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: Git" $1

  # if test "$DOTFILES_DRY_RUN" -eq 0; then
    ### Create build gitconfig
    local gitconfig="$(cat "gitconfig" 2>/dev/null)"

    if [[ -d "$base_dir/extra" ]]; then
      for file in "$base_dir"/extra/{**,}/*gitconfig_local(.N); do
        local gitconfig="${gitconfig}\n\n$(cat "$file" 2>/dev/null)"
      done
      unset file
    fi

    echo "$gitconfig" > "$build_dir/gitconfig"

    ### Symlink gitconfig
    symlink_files "$build_dir/gitconfig" "$HOME" ""

    ### Create build gitignore_global
    local gitignore="$(cat "gitignore_global" 2>/dev/null)"

    if [[ -d "$base_dir/extra" ]]; then
      for file in "$base_dir"/extra/{**,}/*gitignore_local(.N); do
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