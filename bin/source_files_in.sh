#!/bin/bash
##
## Function to source all files passed as an argument
##

source_files_in() {
  # zsh does not expand a glob in an unquoted parameter
  if [ -n "$ZSH_VERSION" ]; then
    eval 'set -- ${~1}(N)'
  else
    set -- $1
  fi
  for file in "$@"; do
    if test -r "$file"; then
      source "$file"
    fi
  done
  unset file
}
