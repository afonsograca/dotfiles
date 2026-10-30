#!/bin/zsh
##
## Script to install the Glip Glops themes and fonts
##

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_glip_glops_dotfiles() {
  local dry_run=$1
  local repo="$DOTFILES_PATH/build/glip-glops"

  ### Intro
  print_step "Glip Glops"

  if test "$dry_run" -eq 0; then
    ### Download
    if test -d "$repo/.git"; then
      print_substep "Updating..."
      git -C "$repo" pull --ff-only --quiet
    else
      print_substep "Downloading..."
      git clone --quiet https://github.com/afonsograca/Glip-Glops.git "$repo"
    fi

    ### Fonts
    print_substep "Installing fonts..."
    mkdir -p "$HOME/Library/Fonts"
    cp "$repo"/fonts/*.otf "$HOME/Library/Fonts/"

    ### Themes
    local theme
    for theme in "$repo"/themes/Ghostty/*; do
      symlink_files "$theme" "$HOME/.config/ghostty/themes" "" false
    done
    symlink_files "$repo/themes/Zed/themes/glip-glops.json" "$HOME/.config/zed/themes" "" false
    for theme in "$repo"/themes/Xcode/*.xccolortheme; do
      symlink_files "$theme" "$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes" "" false
    done

    ### Terminal
    # Terminal has no command to import a profile. When you open a profile file, Terminal imports it and opens a window.
    local profile
    for profile in "$repo"/themes/Terminal/*.terminal; do
      if ! /usr/libexec/PlistBuddy -c "Print ':Window Settings:${profile:t:r}'" "$HOME/Library/Preferences/com.apple.Terminal.plist" >/dev/null 2>&1; then
        print_substep "Importing Terminal profile ${profile:t:r}..."
        open "$profile"
      fi
    done
  fi

  ### Finishing touches
  print_step "Glip Glops — DONE!"
}

handle_glip_glops_dotfiles $1

unset -f handle_glip_glops_dotfiles
