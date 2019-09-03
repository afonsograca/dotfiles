#!/bin/bash
##
## Helper functions to symlink files
##

# dirname=$(dirname $0)
# absolute_path=$(cd $dirname; pwd)
# parent_directory_path=$(dirname $absolute_path)

# Usage:
# $1 - location
remove_broken_links() {
  if test "$#" != 1; then
    echo "Error: this function takes exactly 1 argument - location."
    exit 1
  fi
  local broken_links="$(find -L $1 -type l -maxdepth 1)"
  for link in $broken_links; do
    unlink "$link"
  done
  unset link
}

# Usage:
# $1 - source files
# $2 - destionation
# $3 - symlink name
# $4 - is hidden symlink (default hidden)
symlink_files() {
  if test $# -lt 2 || test $# -gt 4; then
    echo "Error: this function takes 2 to 4 arguments:"
    echo "Mandatory: the file(s) to symlink and the destination."
    echo "Optional: the name of the symlink and if it should be hidden or not (default hidden)"
    exit 1
  fi
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/.."; pwd)"
  fi
  source "$base_dir/bin/print_utils.sh"
  
  remove_broken_links $2
  
  local should_be_hidden="true"
  
  if test  "$4" = "false" || test "$4" = "False"; then
    local should_be_hidden="false"
  fi
  
  for file in "$1"; do
    local symlink_name="$(basename $file)"
    
    if test "$3" != ""; then
      local symlink_name="$3"
    fi
    
    print_step "Creating symlink for $symlink_name"
    
    source_file="$file"
    symlink="$2/$( test "$should_be_hidden" = "true" && echo ".")$symlink_name"

    ln -sfn $source_file $symlink
  done
  unset file
}
