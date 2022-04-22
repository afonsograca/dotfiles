#!/bin/sh
##
## Script to setup all system shell (zsh) files 
##

handle_shell_dotfiles() {

  local dry_run=$2

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.."; pwd)"
  fi
  local shell_dir="$base_dir/shell"
  mkdir -p "$base_dir/build"
  local build_dir="$base_dir/build"

  mkdir -p "$build_dir/zsh"
  local zsh_dir="$build_dir/zsh"
  
  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_header_footer "Step: Shell" $1

  if test "$dry_run" -eq 0; then
    print_substep "NOT DRY RUN"
    # ### Set zsh as the default shell
    # if  [ "$SHELL" != "/bin/zsh" ]; then
    #   print_step "Setting the Shell type"
    #   chsh -s /bin/zsh
    # fi
    
    # ### Symlink environment
    # cat "$shell_dir/zshenv" > "$zsh_dir/.zshenv" 2>/dev/null

    # for file in "$base_dir"/extra/{**/,}*zshenv*; do
    #   if [ -s "$file" ]; then
    #     (echo; echo; cat "$file") >> "$zsh_dir/zshenv" 2>/dev/null
    #   fi
    # done
    # unset file
    # symlink_files "$zsh_dir/.zshenv" "$HOME" "zshenv"

    # ### Setup paths

    # ### Symlink zsh files
    
    # ## Profile configurations
    # cp "$shell_dir/zshrc" "$zsh_dir/.zshrc"

    # ## Interactive configurations
    # cp "$shell_dir/zshrc" "$zsh_dir/.zshrc"

    # symlink_files $zsh_dir "$HOME"
  fi

  ### Finishing touches
  print_header_footer "Step: System — DONE!"
}

handle_shell_dotfiles $1 $2

unset -f handle_shell_dotfiles
