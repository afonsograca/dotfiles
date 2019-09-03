#!/bin/sh
##
## Script to install Python, Pyenv and its configs
##

### Intro
echo "\n   Step: Python & Pyenv\n"


### Make sure Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Please make sure Homebrew is installed before installing Python/Pyenv"
  exit 1
fi

### Make sure Homebrew is up to date
echo "Updating Homebrew...\n"
brew update >/dev/null 2>&1


### Make sure Python 2.7 is installed & up to date
if brew ls --versions python@2 >/dev/null 2>&1; then
  echo "=> Checking for Python 2 updates..."
  if brew upgrade python@2 2>/dev/null; then
    echo "Update complete!"
  else
    echo "Python 2 is already up to date!"
  fi
else
  echo "=> Installing Python 2..."
  brew install python@2
fi
echo ""


### Make sure Pyenv is installed & up to date
if brew ls --versions pyenv >/dev/null 2>&1; then
  echo "=> Trying to update Pyenv..."
  if brew upgrade pyenv 2>/dev/null; then
    echo "Update complete!"
  else
    echo "Pyenv is already up to date!"
  fi
else
  echo "=> Installing Pyenv..."
  brew install pyenv
fi
echo ""


echo "=> Configuring Pyenv"
### Make Python 2 the default
pyenv global system

pyenv rehash

echo "Configurations all set!"

### Load user-specific definitions
base_dir="$(cd "$(dirname "$0")/../.."; pwd)"
user_definitions="$base_dir/extra/{**,}/*pyenv{_install,}_local"
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
echo "\n   Step: Python & Pyenv — DONE!\n"
