# 🚀 Termux Ultimate

> Transform Termux into a modern AI-powered development environment with a single command.

![Version](https://img.shields.io/badge/version-0.1.0--alpha-blue)
![Platform](https://img.shields.io/badge/platform-Termux-green)
![License](https://img.shields.io/badge/license-MIT-yellow)

---

## Features

- 🐚 Oh My Zsh + Powerlevel10k + zsh-autosuggestions + zsh-syntax-highlighting
- 🤖 Ollama (local LLMs)
- 🧠 Gemini CLI
- 🐍 Python Development (pip, IPython)
- 🟢 Node.js Development (npm, pnpm, Yarn)
- 🎥 yt-dlp + FFmpeg
- 🩺 `tu doctor` — health checks
- 🛠 `tu repair` — self repair
- 🔄 `tu update` — self update
- 🗑 `tu uninstall` — clean removal

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

Running the installer again updates an existing install in place (no duplicate clone).

## Usage

After bootstrapping, clone this repo and use the `tu` CLI:

```bash
./tu install shell    # Zsh + Oh My Zsh + Powerlevel10k
./tu install python   # Python, pip, IPython
./tu install node     # Node.js, pnpm, Yarn
./tu install ai       # Ollama + Gemini CLI
./tu install media    # yt-dlp + FFmpeg

./tu doctor           # Check your setup health
./tu repair           # Reinstall anything that is missing
./tu update           # Pull the latest version
./tu uninstall        # Remove the setup
./tu version          # Show the current version
```

Every module is idempotent — safe to run multiple times; already-installed tools are skipped.

---

## Project Status

🚧 Under Active Development

Current Version: **0.1.0-alpha**

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

### v1.0 🚧
- Stable Release
- One-command installer (works, pending polish)
- Self-update
- Self-repair

---

## License

MIT License

---

Made with ❤️ by Sachitt