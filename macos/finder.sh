#!/bin/sh
##
## Script to setup Finder's configurations
##

handle_finder_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Finder"

  if test "$dry_run" -eq 0; then

    ## Appearance
    # TODO
    # Set size

    # Preferred view style to Icon
    defaults write com.apple.finder FXPreferredViewStyle -string icnv

    # Always Open in icon view

    # Browse in icon view

    # Disable stack by

    # Set Sort by to Name

    # Set icon size
    defaults write com.apple.finder FK_StandardViewSettings-dict iconSize -float 64

    # Set Grid spacing
    defaults write com.apple.finder gridSpacing -float 54

    # Set text size
    defaults write com.apple.finder textSize -float 12

    # Set Label position

    # Disable Item Info
    defaults write com.apple.finder showItemInfo -bool false

    # Enable Icon Preview
    defaults write com.apple.finder showIconPreview -bool true

    # Set Background
    defaults write com.apple.finder backgroundType -int 0

    # Show Sidebar
    defaults write com.apple.finder ShowSidebar -bool true

    # Hide Preview
    defaults write com.apple.finder ShowPreviewPane -bool false

    # Show Toolbar
    /usr/libexec/PlistBuddy -c "Set :\"NSToolbar Configuration Browser\":\"TB Is Shown\" 1" "$HOME/Library/Preferences/com.apple.Safari.plist"

    # Hide Tab bar
    defaults write com.apple.finder ShowTabView -bool false

    # Hide Path bar
    defaults write com.apple.finder ShowPathbar -bool false

    # Show Status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    ## General

    # Show Hard Drives on Desktop
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

    # Show External Disks on Desktop
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

    # Show Removable Media on Desktop
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

    # Show Connected Servers on Desktop
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

    # New Finder window to User Home
    defaults write com.apple.finder NewWindowTarget -string PfHm

    # Disable Open folders in Tabs
    defaults write com.apple.finder FinderSpawnTab -bool false

    ## Tags

    ## Sidebar
    # TODO

    # Set width
    defaults write com.apple.finder SidebarWidth -float 172

    ## Advanced

    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool false

    # Show warning before changing extensions
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true

    # Show warning before removing from iCloud
    defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool true

    # Show warning before emptying Bin
    defaults write com.apple.finder WarnOnEmptyTrash -bool true

    # Remove after 30 days in Bin
    defaults write com.apple.finder FXRemoveOldTrashItems -bool false

    # Keep folder on top while sort by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool false

    # Keep folder on top in Desktop
    defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

    # Search in current folder
    defaults write com.apple.finder FXDefaultSearchScope -string SCcf

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  fi

  ### Finishing touches
  print_step "Finder — DONE!"
}

handle_finder_dotfiles $1

unset -f handle_finder_dotfiles
