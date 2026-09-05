# Release Notes

Ready-to-paste notes for each tagged release. On GitHub: **Releases → New
release → choose the tag** and paste the matching section.

---

## v0.1.3

### Added
- `tu upgrade` — update + repair in one command (also in the menu)
- New **lazygit** module — terminal UI for git (`tu install lazygit`)
- New **lang** module — Rust + Go toolchains (`tu install lang`)
- `termux-api` support — clipboard, wake-lock, battery, and the `open` alias
- README banner + `RELEASES.md`

### Fixed
- Module picker range updated for the two new modules (1–7)

---

## v0.1.2

### Added
- `tu doctor` suggests exact fixes for missing items (`tu install shell`, …)
- `tu env` — compact environment summary
- `open` alias for `termux-open-url`
- `jq` and `tldr` tools in the shell module

---

## v0.1.1

### Added
- Dracula theme (`theme dracula`)
- `tu logs` — view the install log
- Uninstall confirmation (type `yes`; non-interactive runs are refused)
- `uv` in the python module
- Storage access setup (`termux-setup-storage`)
- More git aliases: `gd`, `gpf`, `gundo`, `gclean`
- Module descriptions in the install pickers
- `AGENTS.md`

### Fixed
- Stale `0.1.0-alpha` fallback version in `install.sh`

---

## v0.1.0

First stable release.

### Added
- One-command installer with interactive module selection
- Module system: shell, python, node, ai, media
- `tu` CLI with interactive menu, module picker, and tab completion
- `tu doctor` / `tu repair` / `tu update` / `tu uninstall` (full + per-module)
- Backup & restore (`tu backup` / `tu restore`)
- Catppuccin & Tokyo Night themes
- tmux config, git aliases, fastfetch config
- Dev tools: eza, bat, fd, ripgrep, btop, htop
- CI (bash -n + shellcheck), `TESTING.md`, `.gitattributes`

### Fixed
- CRLF line endings in committed scripts (would have broken on Termux)
- `tu` symlink resolution when installed to PATH