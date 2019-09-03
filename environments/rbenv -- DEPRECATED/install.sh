#!/bin/sh
##
## Script to install Ruby, Rbenv, its configs
##

### Intro
echo "\n   Step: Ruby, Rbenv & Gems\n"



### Make sure Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Please make sure Homebrew is installed before installing Python/Pyenv"
  exit 1
fi

### Make sure Homebrew is up to date
echo "Updating Homebrew...\n"
brew update >/dev/null 2>&1


### Make sure Ruby is installed & up to date
if brew ls --versions ruby >/dev/null 2>&1; then
  echo "=> Checking for Ruby updates..."
  if brew upgrade ruby 2>/dev/null; then
    echo "Update complete!"
  else
    echo "Ruby is already up to date!"
  fi
else
  echo "=> Installing Ruby..."
  brew install ruby
fi
echo ""


### Make sure Rbenv is installed & up to date
if brew ls --versions rbenv >/dev/null 2>&1; then
  echo "=> Checking for Rbenv updates..."
  if brew upgrade rbenv 2>/dev/null; then
    echo "Update complete!"
  else
    echo "Rbenv is already up to date!"
  fi
else
  echo "=> Installing Rbenv..."
  brew install rbenv
fi
echo ""


echo "=> Configuring Rbenv"
### Make Brew's ruby the default
rbenv global system

rbenv rehash

### Load user-specific definitions
base_dir="$(cd "$(dirname "$0")/../.."; pwd)"
user_definitions="$base_dir/extra/{**,}/*rbenv{_install,}_local"
if ! command -v source_files_in >/dev/null 2>&1; then
  source "$base_dir/bin/source_files_in.sh"
  source_files_in $user_definitions
  unset source_files_in
else
  source_files_in $user_definitions
fi
unset base_dir
unset user_definitions

echo "Configurations all set!"

### Finishing touches
echo "\n   Step: Python & Pyenv — DONE!\n"
