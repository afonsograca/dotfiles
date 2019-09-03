#!/bin/sh
##
## Script to install Yarn and its configs & packages
##


### Intro
echo "\n   Step: Yarn & Packages\n"


### Make sure yarn is installed
if ! command -v yarn >/dev/null 2>&1; then
  ### Make sure Homebrew is installed
  if ! command -v brew >/dev/null 2>&1; then
    echo "Please make sure Homebrew is installed before installing Python/Pyenv"
    exit 1
  fi
  echo "=> Installing Yarn..."
  brew install yarn
fi


### Symlink package.json
base_dir="$(cd "$(dirname "$0")/../.."; pwd)"
yarn_global_dir="$(yarn global dir)"
if ! command -v symlink_files >/dev/null 2>&1; then
  source "$base_dir/bin/symlink_dotfiles.sh"
fi

symlink_files "$base_dir/packages/yarn/package.json" "$yarn_global_dir" "package.json" false
echo ""

unset base_dir


### Install and update all your packages
echo "=> Trying to install/update your packages..."
if ! yarn global upgrade 2>/dev/null; then
  (cd "$yarn_global_dir"; yarn install)
fi
echo ""
unset yarn_global_dir

### Finishing touches
echo "\n   Step: Yarn & Packages — DONE!\n"