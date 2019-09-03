#!/bin/bash
##
## Function to source all files passed as an argument
##

source_files_in() {
  for file in $1; do
    if test -r $file; then
      source $file
    fi
  done
  unset file
}
