#!/bin/zsh
## 
## Helper method to install a tool via mise (https://mise.jdx.dev/)
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

  ### Make sure Homebrew is installed
  if ! command -v brew >/dev/null 2>&1; then
    printf "Please make sure Homebrew is installed before installing $tool\n"
    exit 1
  fi

  ### Make sure mise is installed & up to date
  if command -v asdf >/dev/null 2>&1; then
    print_substep "Checking if we're running the latest version of asdf..."
    brew upgrade asdf >/dev/null 2>&1
  else
    print_substep "Installing asdf..."
    brew install asdf >/dev/null
  fi

  ### Install asdf's Tool plugin
  if ! asdf plugin list | grep -q $tool; then
    print_substep "Installing asdf's $tool plugin..."
    asdf plugin add $tool >/dev/null
  fi

  # ### Install Tool plugin
  if ! (asdf current $tool 2> /dev/null) | grep -q $(asdf latest $tool 2> /dev/null) 2> /dev/null; then
    print_substep "Installing latest version of $tool..."
    asdf install $tool latest >/dev/null 2>&1
    asdf global $tool latest >/dev/null
  fi
}
