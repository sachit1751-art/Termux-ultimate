#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Shell Module
# Handles Zsh + Oh My Zsh + Powerlevel10k setup

set -e

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)/shell"

echo "================================="
echo " Termux Ultimate Shell Installer"
echo "================================="

START=$(date +%s)

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

bash "$MODULE_DIR/install.sh"
bash "$MODULE_DIR/plugins.sh"
bash "$MODULE_DIR/config.sh"
bash "$MODULE_DIR/fastfetch.sh"
bash "$MODULE_DIR/tmux.sh"
bash "$MODULE_DIR/git.sh"

echo
echo "✓ Shell setup completed"
echo "  zsh + Oh My Zsh + Powerlevel10k"
echo "  plugins: zsh-autosuggestions, zsh-syntax-highlighting"
echo "  theme: Catppuccin (switch with 'theme tokyonight')"
echo "  tmux config + git config + fastfetch"
echo "  dev tools: eza, bat, fd, ripgrep, jq, tldr + btop/htop"
echo "  termux-api: clipboard, wake-lock, open links"
echo "  elapsed: $(($(date +%s) - START))s"
echo
echo "Restart Termux or run: zsh"
