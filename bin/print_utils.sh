##
## Helper functions to print content to the shell
##

print_header_footer() {
  local indent="   "
  printf "\n"
  printf "${indent}$*\n"
  printf "\n"
}

print_step() {
  local indent="=>"
  printf "${indent} $*"
  printf "\n"
}