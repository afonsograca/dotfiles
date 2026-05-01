#!/bin/zsh
##
## Script to build and install AI assistant config (skills, MCP) for Cursor, Claude Code, and Zed
##
## Layout:
##   ai/skills/     -> merged to build/ai/skills, then symlinked to:
##                       ~/.cursor/skills (Cursor — personal skills; Cursor-created live in skills-cursor)
##                       ~/.claude/skills (Claude Code)
##                       ~/Library/Application Support/Zed/User/rules (Zed)
##   ai/mcp/        -> merged to build/ai/mcp, then:
##                       build/ai/mcp/mcp.json  -> ~/.cursor/mcp.json (Cursor)
##                       build/ai/mcp/claude.json -> ~/.claude.json (Claude Code)
##   extra/ai/skills and extra/ai/mcp overlay the same structure if present.
##
## In container context ($REMOTE_CONTAINERS or $CODESPACES set):
##   - skills are copied directly into ~/.claude/skills (no symlinks, so they survive
##     after the dotfiles repo is no longer mounted)
##   - Cursor, Zed, and MCP config are skipped (host-only tools)
##
trap '' TERM

if [ -z "${DOTFILES_PATH+set}" ]; then
  _d="$(cd "$(dirname "$0")" && pwd)"
  while [ ! -f "$_d/bin/init_installer.sh" ]; do _d="$(dirname "$_d")"; done
  export DOTFILES_PATH="$_d"
  unset _d
fi
. "$DOTFILES_PATH/bin/init_installer.sh"

handle_ai_dotfiles() {
  local dry_run=${2:-0}
  local build_dir="$DOTFILES_PATH/build/ai"
  mkdir -p "$build_dir"

  # Detect container context
  local in_container=0
  if [[ -n "$REMOTE_CONTAINERS" || -n "$CODESPACES" ]]; then
    in_container=1
  fi

  ### Intro
  print_header_footer "Step: AI" $1

  if test "$dry_run" -eq 0; then
    ### Build: copy ai/skills and ai/mcp to build/ai, merging extra if present
    print_step "Building AI config (skills, mcp)"
    mkdir -p "$build_dir/skills" "$build_dir/mcp"

    if [[ -d "$DOTFILES_PATH/ai/skills" ]]; then
      cp -R "$DOTFILES_PATH/ai/skills"/. "$build_dir/skills/" 2>/dev/null || true
    fi
    if [[ -d "$DOTFILES_PATH/extra/ai/skills" ]]; then
      cp -R "$DOTFILES_PATH/extra/ai/skills"/. "$build_dir/skills/" 2>/dev/null || true
    fi

    if [[ -d "$DOTFILES_PATH/ai/mcp" ]]; then
      cp -R "$DOTFILES_PATH/ai/mcp"/. "$build_dir/mcp/" 2>/dev/null || true
    fi
    if [[ -d "$DOTFILES_PATH/extra/ai/mcp" ]]; then
      cp -R "$DOTFILES_PATH/extra/ai/mcp"/. "$build_dir/mcp/" 2>/dev/null || true
    fi

    if [[ $in_container -eq 1 ]]; then
      ### Container: copy skills directly into ~/.claude/skills (no symlinks).
      ### Skip if skills are already accessible (e.g. via host bind mount).
      print_step "Installing to Claude Code (container mode — copying files)"
      if [[ -d "$build_dir/skills" && ! -d "$HOME/.claude/skills" ]]; then
        mkdir -p "$HOME/.claude/skills"
        cp -rL "$build_dir/skills"/. "$HOME/.claude/skills/" 2>/dev/null || true
      fi
    else
      ### Host: symlink to assistants
      print_step "Linking to Cursor, Claude Code, and Zed"

      # Cursor: skills -> ~/.cursor/skills (personal); mcp -> ~/.cursor/mcp.json
      mkdir -p "$HOME/.cursor"
      if [[ -d "$build_dir/skills" ]]; then
        symlink_files "$build_dir/skills" "$HOME/.cursor" "skills" false
      fi
      if [[ -f "$build_dir/mcp/mcp.json" ]]; then
        symlink_files "$build_dir/mcp/mcp.json" "$HOME/.cursor" "mcp.json" false
      fi

      # Claude Code: skills -> ~/.claude/skills, MCP -> ~/.claude.json
      mkdir -p "$HOME/.claude"
      if [[ -d "$build_dir/skills" ]]; then
        symlink_files "$build_dir/skills" "$HOME/.claude" "skills" false
      fi
      if [[ -f "$build_dir/mcp/claude.json" ]]; then
        symlink_files "$build_dir/mcp/claude.json" "$HOME" ".claude.json" false
      fi

      # Zed: user rules (Rules Library content)
      local zed_user="$HOME/Library/Application Support/Zed/User"
      mkdir -p "$zed_user"
      if [[ -d "$build_dir/skills" ]]; then
        symlink_files "$build_dir/skills" "$zed_user" "rules" false
      fi
    fi
  fi

  ### Finishing touches
  print_header_footer "Step: AI — DONE!"
}

handle_ai_dotfiles "$@"
unset -f handle_ai_dotfiles

trap - TERM
