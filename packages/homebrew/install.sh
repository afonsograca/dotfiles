#!/bin/sh
##
## Script to install & update Homebrew
##

### Includes
if test -z "${base_dir+empty}"; then
  base_dir="$(cd "$(dirname "$0")/../.."; pwd)"
fi
  
if ! command -v activate_sudo >/dev/null 2>&1; then
  source "$base_dir/bin/sudo.sh"
fi
  
if ! command -v print_header_footer >/dev/null 2>&1; then
  source "$base_dir/bin/print_utils.sh"
fi

# FIXME needs xcode-select --install first

### Intro
print_header_footer "Step: Homebrew"

activate_sudo


### Make sure Brew is installed & up to date
if ! command -v brew >/dev/null 2>&1; then
  print_step "Installing brew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  print_step "Updating brew..."
  brew update
fi


### Create Brewfile.lock
brewfile="$(cat "$base_dir/packages/homebrew/Brewfile" 2>/dev/null)"

for file in "$base_dir"/extra/{**,}/*Brewfile_local; do
  brewfile="${brewfile}\n\n$(cat "$file" 2>/dev/null)"
done
unset file

echo "$brewfile" > "$base_dir/packages/homebrew/Brewfile.lock"


### Symlink Brewfile.lock
if ! command -v symlink_files >/dev/null 2>&1; then
  source "$base_dir/bin/symlink_dotfiles.sh"
fi

symlink_files "$base_dir/packages/homebrew/Brewfile.lock" "$HOME" "Brewfile"

unset brewfile

### Install and update all your brews and casks
print_step "Installing/Updating taps/brews/casks/fonts..."
if ! brew bundle check --global >/dev/null 2>&1; then
  brew bundle --global
fi

brew upgrade
brew cask upgrade

### Remove outdated versions from the cellar.
brew cleanup

print_header_footer "Step: Homebrew DONE!"

# FIXME
unset -f base_dir