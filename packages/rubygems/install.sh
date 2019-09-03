#!/bin/sh
##
## Script to install Rubygems, Bundler and its configs
##


### Intro
echo "\n   Step: RubyGems & Bundler\n"


### Make sure RubyGems is installed
if ! command -v gem >/dev/null 2>&1; then
  echo "Please make sure RubyGems is installed before installing Bundler and Gems"
  exit 1
fi

### Make sure you're not using system's RubyGems
if test "command -v brew" = "/usr/bin/gem"; then
  echo "Please make sure you're not using the system's RubyGems"
  exit 1
fi


### Make sure RubyGems is updated
echo "=> Checking for RubyGems updates..."
gem update --system
echo ""


### Make sure Bundler is installed
if ! command -v bundle >/dev/null 2>&1; then
  echo "=> Installing Bundler..."
  gem install bundler --no-document
fi


### Create Gemfile.lock
base_dir="$(cd "$(dirname "$0")/../.."; pwd)"

gemfile="$(cat "$base_dir/packages/rubygems/Gemfile" 2>/dev/null)"

for file in "$base_dir"/extra/{**,}/*Gemfile_local; do
  gemfile="${gemfile}\n\n$(cat "$file" 2>/dev/null)"
done
unset file

echo "$gemfile" > "$base_dir/packages/rubygems/Gemfile.lock"


### Symlink Brewfile.lock
if ! command -v symlink_files >/dev/null 2>&1; then
  source "$base_dir/bin/symlink_dotfiles.sh"
fi

symlink_files "$base_dir/packages/rubygems/Gemfile.lock" "$HOME/.gem" "Gemfile" false
echo ""

unset base_dir
unset gemfile


### Install and update all your gems
echo "=> Trying to install/update your gems..."
(cd "$HOME/.gem"; bundle update)
echo ""


### Remove outdated gem versions
echo "=> Cleaning up old gems..."
gem cleanup


### Finishing touches
echo "\n   Step: RubyGems & Bundler — DONE!\n"
