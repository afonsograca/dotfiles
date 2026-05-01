#!/bin/zsh
##
## Script to setup all system shell (zsh) files
##
trap '' TERM

initialize() {
  local dry_run=$1

  # Determine base directory - this should be the dotfiles root
  if [[ -z "${base_dir+empty}" ]]; then
    local script_dir="$(cd "$(dirname "$0")" && pwd)"
    base_dir="$(cd "$script_dir/.." && pwd)"

    # Validate we have the right directory by checking for expected files
    if [[ ! -f "$base_dir/dotfiles" || ! -d "$base_dir/shell" ]]; then
      echo "ERROR: Cannot find dotfiles directory structure"
      echo "Expected to find 'dotfiles' script and 'shell' directory in: $base_dir"
      return 1
    fi
  fi

  # Load source_if_missing utility first
  if [[ -f "$base_dir/bin/source_if_missing.sh" ]]; then
    source "$base_dir/bin/source_if_missing.sh"
  fi

  # Load required utilities using source_if_missing
  if command -v source_if_missing >/dev/null 2>&1; then
    source_if_missing symlink_files "$base_dir/bin/symlink_dotfiles.sh"
    source_if_missing print_header_footer "$base_dir/bin/print_utils.sh"
  else
    # Fallback to manual loading if source_if_missing isn't available
    if ! command -v symlink_files >/dev/null 2>&1; then
      if [[ -f "$base_dir/bin/symlink_dotfiles.sh" ]]; then
        source "$base_dir/bin/symlink_dotfiles.sh"
      fi
    fi

    if ! command -v print_header_footer >/dev/null 2>&1; then
      if [[ -f "$base_dir/bin/print_utils.sh" ]]; then
        source "$base_dir/bin/print_utils.sh"
      fi
    fi
  fi

  # Set up directory paths
  shell_dir="$base_dir/shell"
  build_dir="$base_dir/build"
  zsh_dir="$build_dir/zsh"
  bash_dir="$build_dir/bash"

  # Create build directories
  mkdir -p "$build_dir" "$zsh_dir" "$bash_dir"
}

check_prerequisites() {
  # Ensure zsh is the default shell
  if [[ "$SHELL" != "/bin/zsh" ]]; then
    if command -v print_step >/dev/null 2>&1; then
      print_step "Setting zsh as default shell"
    else
      echo " - Setting zsh as default shell"
    fi
    chsh -s /bin/zsh
  fi
}

build_config_files() {
  if command -v print_step >/dev/null 2>&1; then
    print_step "Building shell configuration files"
  else
    echo " - Building shell configuration files"
  fi

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
        case "$line" in
        *'source "$DOTFILES_PATH/packages/homebrew/path"'*)
          if [[ -f "$base_dir/packages/homebrew/path" ]]; then
            echo "# Homebrew (inlined)"
            cat "$base_dir/packages/homebrew/path"
            echo
          fi
          ;;
        *'source "$DOTFILES_PATH/environments/mise/path"'*)
          if [[ -f "$base_dir/environments/mise/path" ]]; then
            echo "# Mise (inlined)"
            cat "$base_dir/environments/mise/path"
            echo
          fi
          ;;
        *'source "$DOTFILES_PATH/environments/path"'*)
          if [[ -f "$base_dir/environments/path" ]]; then
            echo "# Legacy environments (inlined)"
            cat "$base_dir/environments/path"
            echo
          fi
          ;;
        *'source "$DOTFILES_PATH/apps/vscode/path"'*)
          if [[ -f "$base_dir/apps/vscode/path" ]]; then
            echo "# VSCode (inlined)"
            cat "$base_dir/apps/vscode/path"
            echo
          fi
          ;;
        *'source "$DOTFILES_PATH/ssh/path"'*)
          if [[ -f "$base_dir/ssh/path" ]]; then
            echo "# SSH (inlined)"
            cat "$base_dir/ssh/path"
            echo
          fi
          ;;
        *)
          echo "$line"
          ;;
        esac
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
  for file in $(find "$base_dir/extra" -name "*zshenv*" -type f 2>/dev/null); do
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
  if command -v print_step >/dev/null 2>&1; then
    print_step "Creating symlinks"
  else
    echo " - Creating symlinks"
  fi
  if command -v symlink_files >/dev/null 2>&1; then
    symlink_files "$zsh_dir/.zshenv" "$HOME" "zshenv"
    symlink_files "$zsh_dir" "$HOME"
  fi
}

build_bash_config() {
  if command -v print_step >/dev/null 2>&1; then
    print_step "Building bash configuration files"
  else
    echo " - Building bash configuration files"
  fi

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
  if command -v print_step >/dev/null 2>&1; then
    print_step "Creating bash symlinks"
  else
    echo " - Creating bash symlinks"
  fi
  if command -v symlink_files >/dev/null 2>&1; then
    symlink_files "$bash_dir/.bash_profile" "$HOME" ".bash_profile" false
    symlink_files "$bash_dir/.bashrc" "$HOME" ".bashrc" false
  fi
}

main() {
  local dry_run=${2:-0}

  # Initialize first to set up base_dir and utilities
  initialize "$dry_run"

  ### Intro
  if command -v print_header_footer >/dev/null 2>&1; then
    print_header_footer "Step: Shell" $1
  else
    echo "=> Step: Shell"
  fi

  if [[ "$dry_run" -eq 0 ]]; then
    if [[ "$SHELL" == */bash ]]; then
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
  if command -v print_header_footer >/dev/null 2>&1; then
    print_header_footer "Step: Shell — DONE!"
  else
    echo "=> Step: Shell — DONE!"
  fi
}

# Run main function with all arguments
main "$@"

# Cleanup
unset -f initialize check_prerequisites build_config_files build_zshenv create_symlinks build_bash_config create_bash_symlinks main

trap - TERM
