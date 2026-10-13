#!/bin/zsh
##
## Read-only audit of this Mac. It writes only its reports, to build/audit/.
## Homebrew can update its download cache. The reports can contain tokens. Do not share them.
##
## Usage:
##   zsh bin/audit.sh          # full audit
##   zsh bin/audit.sh watch    # find the defaults keys that a settings change writes
##   zsh bin/audit.sh jobs     # list launchd jobs whose program no longer exists
##

setopt null_glob extended_glob
umask 077

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_ENV_HINTS=1

# Use this repo, not an exported DOTFILES_PATH
DOTFILES_PATH="${0:A:h:h}"
AUDIT_DIR="$DOTFILES_PATH/build/audit"
BREWFILE="$DOTFILES_PATH/packages/homebrew/Brewfile"
STAMP="$(date +%Y%m%d-%H%M%S)"

have() { command -v "$1" >/dev/null 2>&1 }

section() {
  local title=$1
  shift
  printf -- "\n### %s\n" "$title"
  "$@" 2>&1
}

brewfile_entries() {
  grep -oE "^[[:space:]]*(brew|cask|mas|tap) ['\"][^'\"]+['\"]" "$1" | sed -E "s/^[[:space:]]*//; s/'/\"/g" | sort -u
}

# The folder can contain old versions. extensions.json contains only the installed versions.
editor_extensions() {
  local dir=$1
  if have jq && test -f "$dir/extensions.json"; then
    jq -r '.[].identifier.id' "$dir/extensions.json" | sort -u
  else
    ls -1 "$dir"
  fi
}

bundle_id() {
  plutil -extract CFBundleIdentifier raw -o - "$1/Contents/Info.plist" 2>/dev/null
}

dump_defaults() {
  local out=$1
  mkdir -p "$out/user" "$out/currentHost"
  for host in user currentHost; do
    local flag=()
    test "$host" = currentHost && flag=(-currentHost)
    { defaults $flag domains | tr ',' '\n' | sed 's/^ *//'; echo NSGlobalDomain } | while read -r domain; do
      test -n "$domain" || continue
      defaults $flag export "$domain" - >"$out/$host/${domain//\//_}.plist" 2>/dev/null
    done
  done
}

audit_apps() {
  section "Installed apps ([mas] = App Store, [cask] = Homebrew, [ ] = manual)" true
  local casks=""
  if have brew && have jq; then
    casks="$(brew info --cask --installed --json=v2 2>/dev/null \
      | jq -r '.casks[].artifacts[]?.app? // empty | .[] | if type == "string" then . else .target end' \
      | xargs -I{} basename {})"
  fi
  for app in /Applications/*.app /Applications/*/*.app ~/Applications/*.app; do
    local name="${app:t}" tag="[ ]   "
    if test -d "$app/Contents/_MASReceipt"; then tag="[mas] "
    elif print -r -- "$casks" | grep -qxF "$name"; then tag="[cask]"
    fi
    printf "%s %-40s %s\n" "$tag" "$name" "$(bundle_id "$app")"
  done
}

audit_packages() {
  # Older Homebrew versions add the homebrew/bundle tap when you use `brew bundle`
  if have brew && brew commands --quiet 2>/dev/null | grep -qx bundle; then
    local dump="$(brew bundle dump --file=- --force 2>/dev/null)"
    section "brew bundle dump (everything currently installed)" print -r -- "$dump"
    section "Installed but NOT in $BREWFILE" \
      comm -13 <(brewfile_entries "$BREWFILE") <(print -r -- "$dump" | brewfile_entries /dev/stdin)
    section "In Brewfile but NOT installed" \
      comm -23 <(brewfile_entries "$BREWFILE") <(print -r -- "$dump" | brewfile_entries /dev/stdin)
  elif have brew; then
    section "brew leaves" brew leaves
    section "brew casks" brew list --cask
  fi
  have mas && section "mas list" mas list
  section "VS Code extensions" editor_extensions ~/.vscode/extensions
  section "Cursor extensions" editor_extensions ~/.cursor/extensions
  have npm && section "npm -g" ls -1 "$(npm root -g --logs-max=0 --no-update-notifier 2>/dev/null)"
  section "pipx" ls -1 "${PIPX_HOME:-$HOME/.local/pipx}/venvs"
  section "uv tools" ls -1 ~/.local/share/uv/tools
  section "cargo bin" ls -1 ~/.cargo/bin
  section "go bin" ls -1 ~/go/bin
  section "mise installs" ls -1 ~/.local/share/mise/installs
  section "asdf installs" ls -1 ~/.asdf/installs
  section "~/.tool-versions" cat ~/.tool-versions
}

audit_home() {
  section "Dotfiles in ~ NOT symlinked into $DOTFILES_PATH" true
  local f target
  for f in ~/.* ~/.config/* ~/.ssh/config ~/.gnupg/*.conf; do
    case "${f:t}" in .DS_Store|.Trash|.CFUserTextEncoding|.cache|.local) continue ;; esac
    if test -L "$f"; then
      target="$(readlink "$f")"
      [[ "$target" == "$DOTFILES_PATH"/* ]] || echo "$f -> $target"
    else
      echo "$f"
    fi
  done
  section "~/Library/Application Support" ls -1 ~/Library/Application\ Support
  section "~/Library/Containers" ls -1 ~/Library/Containers
  section "~/Library/Group Containers" ls -1 ~/Library/Group\ Containers
  section "User fonts" ls -1 ~/Library/Fonts
  section "Services / Quick Actions" ls -1 ~/Library/Services
  section "Keyboard layouts" ls -1 ~/Library/Keyboard\ Layouts
  have shortcuts && section "Shortcuts" shortcuts list
}

audit_system() {
  section "macOS" sw_vers
  section "Arch" uname -m
  section "ComputerName" scutil --get ComputerName
  section "LocalHostName" scutil --get LocalHostName
  section "Login shell" dscl . -read ~ UserShell
  section "Login items" echo "Needs root, run manually: sudo sfltool dumpbtm"
  section "LaunchAgents (user)" ls -1 ~/Library/LaunchAgents
  section "LaunchAgents (system)" ls -1 /Library/LaunchAgents
  section "LaunchDaemons (system)" ls -1 /Library/LaunchDaemons
  section "crontab" crontab -l
  section "pmset" pmset -g custom
  section "FileVault" fdesetup status
  section "Firewall" /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
  section "Network services" networksetup -listallnetworkservices
  section "Printers" lpstat -p
  section "Key remapping (hidutil)" hidutil property --get UserKeyMapping
  section "/etc/shells" cat /etc/shells
  section "/etc/hosts" cat /etc/hosts
  section "/etc/paths.d" ls /etc/paths.d
  section "/etc/pam.d/sudo_local" cat /etc/pam.d/sudo_local
}

##
## Orphans: the results can contain false positives. Examine each item before you remove it.
##

typeset -A installed_ids installed_vendors
installed_names=""

collect_installed() {
  local app id
  { mdfind "kMDItemContentType == 'com.apple.application-bundle'" 2>/dev/null
    print -l /Applications/*.app /Applications/*/*.app ~/Applications/*.app
  } | sort -u | while read -r app; do
    installed_names+="${${app:t:r}:l}"$'\n'
    id="$(bundle_id "$app")"
    test -n "$id" || continue
    id="${id:l}"
    installed_ids[$id]=1
    installed_vendors[${(j:.:)${(s:.:)id}[1,2]}]=1
  done
}

classify() {
  local n="${1:l}" parts prefix i
  n="${n%.plist}"
  n="${n#group.}"
  [[ "$n" == [a-z0-9](#c10).* ]] && n="${n#*.}" # Remove the Team ID
  if [[ "$n" == *.* ]]; then
    parts=(${(s:.:)n})
    for (( i = ${#parts}; i >= 2; i-- )); do
      prefix="${(j:.:)parts[1,i]}"
      (( ${+installed_ids[$prefix]} )) && { echo installed; return }
    done
    (( ${+installed_vendors[${(j:.:)parts[1,2]}]} )) && { echo vendor; return }
  else
    [[ "$installed_names" == *"$n"* ]] && { echo installed; return }
  fi
  echo orphan
}

report_library_orphans() {
  local title=$1 dir=$2 entry name kind
  local -a orphans vendor
  for entry in "$dir"/*; do
    name="${entry:t}"
    [[ "${name:l}" == (com.apple.*|group.com.apple.*|.globalpreferences*|apple*|*.com.apple.*|byhost) ]] && continue
    kind="$(classify "$name")"
    case $kind in
      orphan) orphans+=("$entry") ;;
      vendor) vendor+=("$entry") ;;
    esac
  done
  printf -- "\n### %s — no matching app installed\n" "$title"
  print -l -- $orphans
  printf -- "\n### %s — same vendor still installed (old app or helper?)\n" "$title"
  print -l -- $vendor
}

report_launchd_orphans() {
  local f bin
  printf -- "\n### launchd jobs whose program no longer exists\n"
  for f in ~/Library/LaunchAgents/*.plist /Library/LaunchAgents/*.plist /Library/LaunchDaemons/*.plist; do
    if test -L "$f" && test ! -e "$f"; then
      echo "$f -> broken symlink to $(readlink "$f")"
      continue
    fi
    bin="$(plutil -extract Program raw -o - "$f" 2>/dev/null)"
    test -n "$bin" || bin="$(plutil -extract ProgramArguments.0 raw -o - "$f" 2>/dev/null)"
    if test -z "$bin" && ! plutil -extract Label raw -o - "$f" >/dev/null 2>&1; then
      echo "$f -> no Label key, launchd does not load it"
    elif test -z "$bin"; then
      echo "$f -> no Program key (check manually)"
    elif test ! -e "$bin"; then
      echo "$f -> $bin"
    fi
  done
}

audit_orphans() {
  collect_installed
  report_launchd_orphans
  report_library_orphans "Preferences" ~/Library/Preferences
  report_library_orphans "Application Support" ~/Library/Application\ Support
  report_library_orphans "Containers" ~/Library/Containers
  report_library_orphans "Group Containers" ~/Library/Group\ Containers
  report_library_orphans "Caches" ~/Library/Caches
}

full_audit() {
  local out="$AUDIT_DIR/$STAMP"
  mkdir -p "$out"
  echo "Writing audit to $out"
  echo " - apps";     audit_apps     >"$out/apps.txt"
  echo " - packages"; audit_packages >"$out/packages.txt"
  echo " - home";     audit_home     >"$out/home.txt"
  echo " - system";   audit_system   >"$out/system.txt"
  echo " - orphans";  audit_orphans  >"$out/orphans.txt"
  echo " - defaults (takes a minute)"; dump_defaults "$out/defaults"
  echo "Done."
}

watch_defaults() {
  local out="$AUDIT_DIR/watch/$STAMP"
  echo "Snapshotting defaults..."
  dump_defaults "$out/before"
  echo "Now change the setting(s) in System Settings / the app, then press Enter."
  read -r
  dump_defaults "$out/after"
  (cd "$out" && diff -ru before after) | tee "$out/diff.txt"
}

mkdir -p "$AUDIT_DIR"
case "${1:-}" in
  watch) watch_defaults ;;
  jobs) report_launchd_orphans ;;
  *) full_audit ;;
esac
