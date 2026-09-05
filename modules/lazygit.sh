#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Lazygit Module
# A simple terminal UI for git commands

set -e

echo "================================="
echo " Termux Ultimate Lazygit Installer"
echo "================================="

START=$(date +%s)

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

echo "[1/1] Installing lazygit..."

if ! command -v lazygit >/dev/null 2>&1; then
    pkg install lazygit -y
else
    echo "✓ lazygit already installed"
fi

echo
echo "✓ Lazygit setup completed"
echo "  lazygit: $(command -v lazygit >/dev/null 2>&1 && lazygit --version 2>&1 | head -1 || echo 'not found')"
echo "  elapsed: $(($(date +%s) - START))s"
echo
echo "Try it: cd <repo> && lazygit"