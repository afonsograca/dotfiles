#!/bin/sh
##
## Script to install NVM and packages
##

### Intro
echo "\n   Step: Node & NVM\n"


### Make sure Homebrew is installed
if ! command -v brew >/dev/null 2>&1; then
  echo "Please make sure Homebrew is installed before installing Python/Pyenv"
  exit 1
fi

### Make sure Homebrew is up to date
echo "Updating Homebrew...\n"
brew update >/dev/null 2>&1


### Make sure Node is installed & up to date
if brew ls --versions node >/dev/null 2>&1; then
  echo "=> Trying to update Node..."
  if brew upgrade node 2>/dev/null; then
    echo "Update complete!"
  else
    echo "Node is already up to date!"
  fi
else
  echo "=> Installing Node..."
  brew install node
fi
echo ""


### Make sure NVM is installed & up to date
if test ! -r "$NVM_DIR/nvm.sh"; then
  echo "=> Installing NVM..."
  
  git clone "https://github.com/creationix/nvm.git" "$HOME/.nvm"
  latest_version="$(cd $HOME/.nvm; git describe --abbrev=0 --tags --match "v[0-9]*" origin 2>/dev/null)"
  if test $?; then
    $(cd $HOME/.nvm; git -c advice.detachedHead=false checkout "$latest_version")
  fi
else
  echo "=> Checking for NVM updates..."
  $(cd "$HOME/.nvm"; git fetch origin)
  
  current_version="$(cd $HOME/.nvm; git describe --abbrev=0 --tags 2>/dev/null)"
  latest_version="$(cd $HOME/.nvm; git describe --abbrev=0 --tags --match "v[0-9]*" origin 2>/dev/null)"
  
  if test "$current_version" = "$latest_version" || test -z "$latest_version"; then
    echo "Everything is up to date!"
  else
    echo "==> Updating NVM..."
    $(cd $HOME/.nvm; git -c advice.detachedHead=false checkout $latest_version)
  fi
fi

source "$NVM_DIR/nvm.sh"
echo "\n"


### Symlink NVM's bash completion to bash completion
echo "=> Setting up NVM's bash completion"
ln -sfn "$NVM_DIR/bash_completion" "$(brew --prefix)/etc/bash_completion.d/nvm"
echo "\n"


### Create default-packages.lock
base_dir="$(cd "$(dirname "$0")/../.."; pwd)"
default_packages="$(cat "$base_dir/environments/nvm/default-packages" 2>/dev/null)"

for file in "$base_dir"/extra/{**,}/*default-packages_local; do
  default_packages="${default_packages}\n\n$(cat "$file" 2>/dev/null)"
done
unset file

echo "$default_packages" > "$base_dir/default-packages.lock"


### Symlink default-packages.lock
if ! command -v symlink_files >/dev/null 2>&1; then
  source "$base_dir/bin/symlink_dotfiles.sh"
fi

symlink_files "$base_dir/default-packages.lock" "$NVM_DIR" "default-packages" false
echo ""

unset default_packages

echo "=> Configuring NVM"
### Make system Node the default
nvm alias default system

echo "Configurations all set!"


### Load user-specific definitions
user_definitions="$base_dir/extra/{**,}/*nvm{_install,}_local"
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
echo "\n   Step: Node & NVM — DONE!\n"

