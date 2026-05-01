#!/bin/sh
##
## Entry point for VS Code's dotfiles feature.
## Delegates to the dotfiles orchestrator with the appropriate mode.
##
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -n "$REMOTE_CONTAINERS" ] || [ -n "$CODESPACES" ]; then
  "$DOTFILES_DIR/dotfiles" --mode container
else
  "$DOTFILES_DIR/dotfiles"
fi
