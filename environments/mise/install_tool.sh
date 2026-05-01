#!/bin/zsh
##
## Helper method to install a tool globally via mise (https://mise.jdx.dev/)
##

install_with_mise() {
  if [[ "$#" != 1 ]]; then
    echo "Error: Expected exactly 1 argument - the name of the tool to install."
    exit 1
  fi
  local tool="$1"

  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd "$(dirname "$0")/../.."; pwd)"
  fi

  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi

  ### Make sure mise is installed
  if ! command -v mise >/dev/null 2>&1; then
    printf "Please make sure mise is installed before installing $tool\n"
    exit 1
  fi

  ### Install the latest version globally if not already current
  local latest
  latest=$(mise latest "$tool" 2>/dev/null)
  if ! mise list "$tool" 2>/dev/null | grep -q "$latest"; then
    print_substep "Installing latest version of $tool via mise..."
    mise use --global "$tool@latest" >/dev/null
  fi
}
