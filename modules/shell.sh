#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Shell Module
# Handles Zsh + Oh My Zsh + Powerlevel10k setup

set -e

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)/shell"

echo "================================="
echo " Termux Ultimate Shell Installer"
echo "================================="

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

bash "$MODULE_DIR/install.sh"
bash "$MODULE_DIR/plugins.sh"
bash "$MODULE_DIR/config.sh"

echo
echo "✓ Shell setup completed"
echo "Restart Termux or run: zsh"
