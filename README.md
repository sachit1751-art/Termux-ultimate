# 🚀 Termux Ultimate

> Transform Termux into a modern AI-powered development environment with a single command.

![Version](https://img.shields.io/badge/version-0.1.0-blue)
![Platform](https://img.shields.io/badge/platform-Termux-green)
![License](https://img.shields.io/badge/license-MIT-yellow)

---

## Features

- 🐚 Oh My Zsh + Powerlevel10k + zsh-autosuggestions + zsh-syntax-highlighting
- 🎨 Catppuccin, Tokyo Night & Dracula themes (`theme catppuccin|tokyonight|dracula|default`)
- 🖥️ tmux with a ready-made config
- ⚙️ Git aliases and sane defaults
- 📈 btop / htop
- 🔍 Dev tools: eza, bat, fd, ripgrep (with aliases)
- 📊 Fastfetch with a theme-aware config
- 🤖 Ollama (local LLMs)
- 🧠 Gemini CLI
- 🐍 Python Development (pip, IPython)
- 🟢 Node.js Development (npm, pnpm, Yarn)
- 🎥 yt-dlp + FFmpeg
- 🩺 `tu doctor` — health checks + update check
- 🛠 `tu repair` — self repair
- 🔄 `tu update` — self update
- 🗑 `tu uninstall` — full or per-module removal
- 💾 `tu backup` / `tu restore` — dotfile backup & restore

---

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/sachit1751-art/Termux-ultimate/main/install.sh | bash
```

This bootstraps the environment (updates packages, installs git), clones the project to `~/.termux-ultimate`, and asks which modules to install:

```
Which modules should I install? (comma-separated numbers, e.g. 1,3,5)
  0) none
  1) shell
  2) python
  3) node
  4) ai
  5) media
> 1,2,3
```

Type `all` for everything, `none` (or just press Enter) to skip. Everything is logged to `~/.termux-ultimate/logs/install.log`.

**Piped (non-interactive) mode:** when the script is piped there is no terminal to prompt, so pass the modules as arguments instead:

```bash
curl -fsSL https://raw.githubusercontent.com/sachit1751-art/Termux-ultimate/main/install.sh | bash -s shell python ai
```

Running the installer again updates an existing install in place (no duplicate clone). It also requests storage access via `termux-setup-storage` so downloads and projects can live in shared folders.

## Usage

The installer puts `tu` on your PATH, so just type `tu` anywhere:

```bash
tu              # Interactive menu (no arguments needed)
tu doctor       # Check your setup health
tu repair       # Reinstall anything that is missing
tu update       # Pull the latest version
tu uninstall        # Remove the setup
tu uninstall shell  # ...or just one module
tu backup           # Back up your dotfiles
tu restore <file>   # Restore from a backup
tu logs             # View the install log
tu version          # Show the current version

tu install          # Module picker (interactive)
tu install shell    # Or install a specific module
tu install python   # Python, pip, IPython
tu install node     # Node.js, pnpm, Yarn
tu install ai       # Ollama + Gemini CLI
tu install media    # yt-dlp + FFmpeg
```

Running `tu` with no arguments opens a friendly menu — pick an action with a number, install multiple modules, and press `0` to exit. Every module is idempotent — safe to run multiple times; already-installed tools are skipped.

Nice extras:

- **Tab completion** — type `tu <TAB>` to complete commands, and `tu install <TAB>` to complete modules.
- **Update check** — `tu doctor` compares your local version against the latest release and tells you when to run `tu update`.
- **`tu doctor` exit code** — exits non-zero when something is missing, so it can be used in scripts.

---

## Project Status

✅ First stable release (v0.1.0)

Current Version: **0.1.0**

---

## Roadmap

### v0.1 ✅
- Repository setup
- Bootstrap installer
- Logging
- Package manager

### v0.2 ✅
- Zsh
- Oh My Zsh
- Powerlevel10k

### v0.3 ✅
- AI Tools
- Ollama
- Gemini CLI

### v0.4 ✅
- Fastfetch
- tmux
- Themes

### v0.5 ✅
- Interactive menu and tab completion
- Backup & restore
- Per-module uninstall
- CI with syntax checks
- LF line endings everywhere

### v1.0 🚧
- Stable Release (v0.1.0 shipped — v1.0 is the polished milestone)
- One-command installer ✅
- Self-update ✅
- Self-repair ✅

---

## License

MIT License

---

Made with ❤️ by Sachitt