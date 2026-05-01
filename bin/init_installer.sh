##
## Installer bootstrap: sources all pure, side-effect-free utilities.
## Assumes DOTFILES_PATH is already exported in the environment.
##
## Usage (standard preamble for every installer):
##
##   if [ -z "${DOTFILES_PATH+set}" ]; then
##     _d="$(cd "$(dirname "$0")" && pwd)"
##     while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
##     export DOTFILES_PATH="$_d"
##     unset _d
##   fi
##   . "$DOTFILES_PATH/bin/init_installer.sh"
##

. "$DOTFILES_PATH/bin/print_utils.sh"
. "$DOTFILES_PATH/bin/symlink_dotfiles.sh"
. "$DOTFILES_PATH/bin/source_files_in.sh"
