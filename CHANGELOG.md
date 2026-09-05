# Changelog

## v0.1.3 — 2026-09-05

### Added
- `tu upgrade` — update + repair in one step (also in the menu)
- **lazygit** module — terminal UI for git (`tu install lazygit`)
- **lang** module — Rust + Go toolchains (`tu install lang`)
- `termux-api` support in the shell module (clipboard, wake-lock, `open` alias)
- README banner (`assets/banner.svg`) and `RELEASES.md` with ready-to-paste notes

### Fixed
- Module picker range (1–7) for the two new modules

## v0.1.2 — 2026-09-05

### Added
- `tu doctor` now suggests exact fixes for missing items (e.g. `tu install shell`)
- `tu env` prints a compact environment summary (version, prefix, home, uptime)
- `open` alias for `termux-open-url` (open links in the Android browser)
- `jq` and `tldr` tools in the shell module

### Fixed
- Doctor suggestions now survive word-splitting (uses bash arrays)

## v0.1.1 — 2026-09-05

### Added
- Dracula theme (`theme dracula`)
- `tu logs` to view the install log
- Uninstall confirmation prompt (full uninstall requires typing `yes`)
- `uv` (fast Python package/venv manager) in the python module
- Storage access setup (`termux-setup-storage`) in the installer
- More git aliases: `gd`, `gpf`, `gundo`, `gclean`
- Module descriptions in the install pickers
- `AGENTS.md` guide for AI agents working on this repo

### Fixed
- Stale `0.1.0-alpha` fallback version in `install.sh`

## v0.1.0 — 2026-09-05

First stable release. The complete roadmap from the README is implemented.

### Added
- One-command installer with interactive module selection (`all` / numbers / args)
- Module system: shell, python, node, ai, media — all idempotent
- `tu` CLI with an interactive menu, module picker, and tab completion
- `tu doctor` (health checks + update check), `tu repair`, `tu update`, `tu uninstall`
- Per-module uninstall: `tu uninstall <module>`
- Backup & restore: `tu backup` / `tu restore <file>`
- Catppuccin & Tokyo Night themes with a `theme` switcher
- Ready-made `.tmux.conf`, git aliases and defaults, fastfetch config
- Dev tools: eza, bat, fd, ripgrep, btop, htop
- CI workflow running `bash -n` + shellcheck on every push and PR
- `.gitattributes` enforcing LF line endings

### Fixed
- CRLF line endings in committed scripts (would have broken every script on real Termux)
- `tu` resolving to the wrong directory when invoked via its `$PREFIX/bin` symlink
- Menu continuing after uninstall, and other small edge cases