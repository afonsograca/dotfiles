#!/bin/zsh
##
## Script to setup all system shell (zsh) files
##
trap '' TERM

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

initialize() {
  shell_dir="$DOTFILES_PATH/shell"
  build_dir="$DOTFILES_PATH/build"
  zsh_dir="$build_dir/zsh"
  bash_dir="$build_dir/bash"
  mkdir -p "$build_dir" "$zsh_dir" "$bash_dir"
}

check_prerequisites() {
  # Ensure zsh is the default shell
  if [[ "$SHELL" != "/bin/zsh" ]]; then
    print_step "Setting zsh as default shell"
    chsh -s /bin/zsh
  fi
}

build_config_files() {
  print_step "Building shell configuration files"

  # Define the inlined source_files_in function
  local source_files_in_function='
# Inline utility function
source_files_in() {
  for file in $1; do
    if test -r $file; then
      source $file
    fi
  done
  unset file
}
'

  # Copy main config files and modify them for the built environment
  # zprofile - remove source_if_missing usage and inline the path files
  {
    echo "$source_files_in_function"
    sed -e '/# Load source_if_missing utility first/,/^fi$/d' \
      -e '/# Load utilities using source_if_missing/d' \
      -e '/source_if_missing source_files_in.*/d' \
      "$shell_dir/zprofile" |
      while IFS= read -r line; do
        if [[ "$line" == *'source "$DOTFILES_PATH/'*'/path"'* ]]; then
          local rel_path="${line##*source \"\$DOTFILES_PATH/}"
          rel_path="${rel_path%%\"*}"
          if [[ -f "$DOTFILES_PATH/$rel_path" ]]; then
            cat "$DOTFILES_PATH/$rel_path"
            echo
          fi
        else
          echo "$line"
        fi
      done
  } >"$zsh_dir/.zprofile"

  # zshrc - remove source_if_missing usage and inline the utility
  {
    echo "$source_files_in_function"
    sed -e '/# Load source_if_missing utility first/,/^fi$/d' \
      -e '/# Load utilities using source_if_missing/d' \
      -e '/source_if_missing source_files_in.*/d' \
      "$shell_dir/zshrc"
  } >"$zsh_dir/.zshrc"

  # Copy supporting files to shell subdirectory
  mkdir -p "$zsh_dir/shell"
  cp "$shell_dir/aliases" "$zsh_dir/shell/"
  cp "$shell_dir/options" "$zsh_dir/shell/"
  cp "$shell_dir/prompts" "$zsh_dir/shell/"

  # Copy functions directory if it exists
  if [[ -d "$shell_dir/functions" ]]; then
    cp -r "$shell_dir/functions" "$zsh_dir/shell/"
  fi
}

build_zshenv() {
  # Build zshenv with extra files
  if [[ -f "$shell_dir/zshenv" ]]; then
    cat "$shell_dir/zshenv" >"$zsh_dir/.zshenv" 2>/dev/null
  fi

  # Append any extra zshenv files
  for file in $(find "$DOTFILES_PATH/extra" -name "*zshenv*" -type f 2>/dev/null); do
    if [[ -s "$file" ]]; then
      {
        echo
        echo
        cat "$file"
      } >>"$zsh_dir/.zshenv" 2>/dev/null
    fi
  done
  unset file
}

create_symlinks() {
  print_step "Creating symlinks"
  symlink_files "$zsh_dir/.zshenv" "$HOME" "zshenv"
  symlink_files "$zsh_dir" "$HOME"
}

build_bash_config() {
  print_step "Building bash configuration files"

  # .bash_profile: entry point for login shells — simply sources .bashrc
  cat >"$bash_dir/.bash_profile" <<'EOF'
##
## Bash login shell entry point
##
[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
EOF

  # .bashrc: interactive shell configuration.
  # Resolves DOTFILES_PATH by following the symlink back to the repo root so
  # the config works regardless of where the repo lives.
  cat >"$bash_dir/.bashrc" <<'EOF'
##
## Bash interactive shell configuration
##
[[ $- != *i* ]] && return

# Resolve DOTFILES_PATH from this file's real path, following symlinks
_bashrc_self="${BASH_SOURCE[0]}"
while [[ -L "$_bashrc_self" ]]; do
  _bashrc_self="$(readlink "$_bashrc_self")"
done
DOTFILES_PATH="$(cd "$(dirname "$_bashrc_self")/../.." && pwd)"
SHELL_PATH="$DOTFILES_PATH/shell"
unset _bashrc_self

source "$SHELL_PATH/aliases"
source "$SHELL_PATH/bash_options"
source "$SHELL_PATH/bash_prompt"

# Load functions — source directly (bash has no autoload)
for _func in "$SHELL_PATH/functions"/*; do
  [[ -r "$_func" ]] && source "$_func"
done
unset _func
EOF
}

create_bash_symlinks() {
  print_step "Creating bash symlinks"
  symlink_files "$bash_dir/.bash_profile" "$HOME" ".bash_profile" false
  symlink_files "$bash_dir/.bashrc" "$HOME" ".bashrc" false
}

main() {
  local dry_run=${2:-0}
  local in_container=${3:-0}

  initialize

  ### Intro
  print_header_footer "Step: Shell" $1

  if [[ "$dry_run" -eq 0 ]]; then
    if [[ "$SHELL" == */bash && $in_container -eq 0 ]]; then
      build_bash_config
      create_bash_symlinks
    else
      check_prerequisites
      build_config_files
      build_zshenv
      create_symlinks
    fi
  fi

  ### Finishing touches
  print_header_footer "Step: Shell — DONE!"
}

main "$@"

unset -f initialize check_prerequisites build_config_files build_zshenv create_symlinks build_bash_config create_bash_symlinks main

trap - TERM
