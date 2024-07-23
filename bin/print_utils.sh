##
## Helper functions to print content to the shell
##

print() {
  local indent=$1
  shift
  printf -- "%s%s\n" "$indent" "$*" 
  printf -- "\n"
}

print_header_footer() {
  local indent="=> "
  printf -- "\n"
  print "$indent" "$*"
}

print_step() {
  local indent=" - "
  print "$indent" "$*"
}

print_substep() {
  local indent="   "
  print "$indent" "$*"
}