#!/bin/sh
##
## Script to install Swiftenv its configs
##

### Intro
echo "\n   Step: Swiftenv\n"


### Make sure Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Please make sure Homebrew is installed before installing Swiftenv"
  exit 1
fi

### Make sure Homebrew is up to date
echo "Updating Homebrew...\n"
brew update >/dev/null 2>&1


### Make sure Swiftenv is installed & up to date
if brew ls --versions swiftenv >/dev/null 2>&1; then
  echo "=> Checking for Swiftenv updates..."
  if brew upgrade kylef/formulae/swiftenv 2>/dev/null; then
    echo "Update complete!"
  else
    echo "Swiftenv is already up to date!"
  fi
else
  echo "=> Installing Swiftenv..."
  brew install kylef/formulae/swiftenv
fi
echo ""


echo "=> Configuring Swiftenv"
### Make system's Swift the default
swiftenv global system

swiftenv rehash

echo "Configurations all set!"

### Load user-specific definitions
base_dir="$(cd "$(dirname "$0")/../.."; pwd)"
user_definitions="$base_dir/extra/{**,}/*swiftenv{_install,}_local"
if ! command -v source_files_in >/dev/null 2>&1; then
  source "$base_dir/bin/source_files_in.sh"
  source_files_in $user_definitions
  unset source_files_in
else
  source_files_in $user_definitions
fi
unset base_dir
unset user_definitions

### Finishing touches
echo "\n   Step: Swiftenv — DONE!\n"
