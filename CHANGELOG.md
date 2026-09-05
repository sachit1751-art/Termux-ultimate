# Changelog

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