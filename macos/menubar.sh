#!/bin/sh
##
## Script to setup the Menu Bar's configurations
##

handle_menu_bar_dotfiles() {
  local dry_run=$1
  
  if test -z "${base_dir+empty}"; then
    local base_dir="$(cd ..; pwd)"
  fi
  
  if ! command -v print_header_footer >/dev/null 2>&1; then
    source "$base_dir/bin/print_utils.sh"
  fi
  
  ### Intro
  print_step "Menu Bar"

  if test "$dry_run" -eq 0; then

    # Automatically hide and show the menu bar on desktop
    defaults write NSGlobalDomain _HIHideMenuBar -bool false

    # Automatically hide and show the menu bar in full screen
    defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -bool false

    # Show Wi-Fi in Menu Bar
    defaults -currentHost write com.apple.controlcenter WiFi -int 2
    defaults write com.apple.controlcenter "NSStatusItem Visible WiFi" -bool true

    # Show Bluetooth in Menu Bar
    defaults -currentHost write com.apple.controlcenter Bluetooth -int 18
    defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true

    # Show Airdrop in Menu Bar
    defaults -currentHost write com.apple.controlcenter AirDrop -int 8
    defaults write com.apple.controlcenter "NSStatusItem Visible AirDrop" -bool false

    # Show Focus in Menu Bar
    defaults -currentHost write com.apple.controlcenter FocusModes -int 2
    defaults write com.apple.controlcenter "NSStatusItem Visible FocusModes" -bool false

    # Show Keyboard Brightness in Menu Bar
    defaults -currentHost write com.apple.controlcenter KeyboardBrightness -int 8
    defaults write com.apple.controlcenter "NSStatusItem Visible KeyboardBrightness" -bool false

    # Show Screen Mirroring in Menu Bar
    defaults -currentHost write com.apple.controlcenter ScreenMirroring -int 2
    defaults write com.apple.controlcenter "NSStatusItem Visible ScreenMirroring" -bool false
    defaults write com.apple.airplay showInMenuBarIfPresent -bool true

    # Show Displays in Menu Bar
    defaults -currentHost write com.apple.controlcenter Display -int 24
    defaults write com.apple.controlcenter "NSStatusItem Visible Display" -bool false

    # Show Sound in Menu Bar
    defaults -currentHost write com.apple.controlcenter Sound -int 18
    defaults write com.apple.controlcenter "NSStatusItem Visible Sound" -bool true

    # Show Now Playing in Menu Bar
    defaults -currentHost write com.apple.controlcenter NowPlaying -int 8
    defaults write com.apple.controlcenter "NSStatusItem Visible NowPlaying" -bool false

    # Show Accessibility Shortcuts in Menu Bar
    defaults -currentHost write com.apple.controlcenter AccessibilityShortcuts -int 9
    defaults write com.apple.controlcenter "NSStatusItem Visible AccessibilityShortcuts" -bool false

    # Show Battery in Menu Bar
    defaults -currentHost write com.apple.controlcenter Battery -int 6
    defaults write com.apple.controlcenter "NSStatusItem Visible Battery" -bool true
    defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool false

    # Show Fast User Switching in Menu Bar
    defaults -currentHost write com.apple.controlcenter UserSwitcher -int 9
    defaults write com.apple.controlcenter "NSStatusItem Visible UserSwitcher" -bool false

    # Show the day of the week
    defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true

    # Show date
    defaults write com.apple.menuextra.clock ShowDayOfMonth -bool true

    # Time Options
    defaults write com.apple.menuextra.clock IsAnalog -bool false

    # Use a 24-hour clock
    defaults delete NSGlobalDomain AppleICUForce12HourTime >/dev/null 2>&1
    defaults write com.apple.menuextra.clock DateFormat "EEE d MMM  hh:mm"

    # Show am/pm
    defaults write com.apple.menuextra.clock ShowAMPM -bool false

    # Flash the time separators
    defaults write com.apple.menuextra.clock FlashDateSeparators -bool false

    # Display the time with seconds
    defaults write com.apple.menuextra.clock ShowSeconds -bool false

    # Announce the time
    defaults delete com.apple.speech.synthesis.general.prefs TimeAnnouncementPrefs >/dev/null 2>&1

    # Show Spotlight in Menu Bar
    defaults -currentHost write com.apple.Spotlight MenuItemHidden -bool true
    defaults delete com.apple.Spotlight "NSStatusItem Visible Item-0" >/dev/null 2>&1

    # Show Siri in Menu Bar
    defaults write com.apple.Siri StatusMenuVisible -bool false

    # Show Time Machine in Menu Bar
    (/usr/libexec/PlistBuddy -c "Delete :menuExtras:\"/System/Library/CoreServices/Menu Extras/TimeMachine.menu\"" "${HOME}/Library/Preferences/com.apple.systemuiserver.plist" >/dev/null 2>&1)
    defaults delete com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.TimeMachine" >/dev/null 2>&1
    defaults delete com.apple.systemuiserver "NSStatusItem Preferred Position com.apple.menuextra.TimeMachine" >/dev/null 2>&1

    # Show Input menu in Menu Bar
    defaults write com.apple.TextInputMenu visible -bool true
  fi

  ### Finishing touches
  print_step "Menu Bar — DONE!"
}

handle_menu_bar_dotfiles $1

unset -f handle_menu_bar_dotfiles