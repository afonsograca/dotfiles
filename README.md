# Dotfiles

Personal macOS dotfiles managed as a modular zsh installer. Each concern lives in its own folder with an `install.sh` that builds config files into `build/` and symlinks them into `$HOME`. An `extra/` overlay lets you layer in private or machine-specific config without touching the tracked files.

Works on macOS (full install) and in VS Code Remote Containers / GitHub Codespaces (shell + git + AI tools only).

## Structure

```
dotfiles/
├── dotfiles          # Main orchestrator — run this to install
├── install.sh        # VS Code dotfiles entry point (delegates to dotfiles)
├── bin/              # Shared utilities (symlinks, printing, sudo, Xcode tools)
├── build/            # Generated output — symlink targets, gitignored
├── extra/            # Private overlay (not tracked) — merged at build time
│
├── shell/            # zsh & bash config (zshrc, zprofile, aliases, functions, prompts)
├── git/              # gitconfig, gitignore_global, gitattributes
├── gpg/              # GPG agent config
├── ssh/              # SSH client config
│
├── packages/
│   ├── homebrew/     # Brewfile + Homebrew install
│   └── rubygems/     # Default gems
│
├── environments/     # Runtime version managers
│   ├── mise/         # mise-en-place config
│   ├── node/
│   ├── ruby/
│   ├── python/
│   ├── elixir/
│   └── swift/
│
├── macos/            # System preferences (defaults write, per-domain scripts)
├── apps/             # App-specific config (VS Code, Chrome, Safari, Terminal…)
│
└── ai/               # AI assistant config
    ├── skills/       # Shared skills → Cursor, Claude Code, and Zed
    └── mcp/          # MCP server config → Cursor (mcp.json) and Claude Code (.claude.json)
```

## Getting started

### macOS

Clone anywhere, then run the orchestrator:

```sh
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./dotfiles
```

Pass `--dry-run` to preview what would happen without making changes.

To run only specific modules, edit the `steps` array near the top of `dotfiles` and uncomment what you want.

### VS Code Remote Containers / GitHub Codespaces

Point VS Code at this repo in your dotfiles settings. The `install.sh` entry point detects the container environment and runs in container mode, which installs shell config, git, and AI skills (no Homebrew, macOS prefs, or app config).

The devcontainer in `.devcontainer/` bind-mounts `~/.claude` and `~/.claude.json` from the host so Claude Code settings and skills are available immediately without reinstalling.

## The `extra/` overlay

Drop private or machine-specific files in `extra/` and the build scripts merge them automatically:

| Path | Merged into |
|---|---|
| `extra/git/*gitconfig_local` | appended to `~/.gitconfig` |
| `extra/zsh/*zshenv*` | appended to `~/.zshenv` |
| `extra/ai/skills/` | merged with `ai/skills/` |
| `extra/ai/mcp/` | merged with `ai/mcp/` |
| `extra/macos/` | applied during macOS step |

`extra/` is gitignored so it never lands in version control.

## AI tools

`ai/skills/` contains skills shared across Cursor, Claude Code, and Zed. The install step symlinks the built `build/ai/skills/` directory to:

- `~/.cursor/skills`
- `~/.claude/skills`
- `~/Library/Application Support/Zed/User/rules`

MCP server config is split by tool:

- `ai/mcp/mcp.json` → `~/.cursor/mcp.json`
- `ai/mcp/claude.json` → `~/.claude.json`

Add private MCP entries in `extra/ai/mcp/` and they'll be merged at install time.

## Acknowledgements

Inspired by the [dotfiles community](https://dotfiles.github.io).
