#!/bin/sh
##
## Script to setup all Visual Studio Code's configurations
##

handle_vscode_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ../..; pwd)"
  fi
  local build_dir="$base_dir/build/vscode"
  mkdir -p $build_dir
    
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  if ! command -v symlink_files >/dev/null 2>&1; then
    source "$base_dir/bin/symlink_dotfiles.sh"
  fi

  ### Intro
  print_step "VS Code"

  if test "$dry_run" -eq 0; then

    ### Settings
    print_substep "Configuring user settings..."

    local settings="$(cat "settings.json" 2>/dev/null)"

    for file in $base_dir/extra/{**,}/*vscode*settings*; do
      local settings="${settings}\n\n$(cat "$file" 2>/dev/null)"
    done
    unset file

    echo "$settings" > "$build_dir/settings.json"

    symlink_files "$build_dir/settings.json" "$HOME/Library/Application Support/Code/User" "" false

    ### Keybindings
    print_substep "Configuring keybindings..."

    local keybindings="$(cat "keybindings.json" 2>/dev/null)"

    for file in $base_dir/extra/{**,}/*vscode*keybindings*; do
      local keybindings="${keybindings}\n\n$(cat "$file" 2>/dev/null)"
    done
    unset file

    echo "$keybindings" > "$build_dir/keybindings.json"

    symlink_files "$build_dir/keybindings.json" "$HOME/Library/Application Support/Code/User" "" false

    ### Snippets
    print_substep "Configuring snippets..."

    local snippets="$build_dir/snippets" 
    mkdir -p snippets
    rsync -a "snippets/" $snippets

    # TODO
    # find . "$base_dir/extra/{**/,}*vscode*snippet*" |while read file; do
    #   cp $file $snippets
    # done
    # unset file

    symlink_files $snippets "$HOME/Library/Application Support/Code/User" "" false

    ### Extensions
    print_substep "Configuring extensions..."

    while IFS= read -r extension; do code --install-extension $extension; done < extensions

  fi

  ### Finishing touches
  print_step "VS Code — DONE!"
}

handle_vscode_dotfiles $1

unset -f handle_vscode_dotfiles