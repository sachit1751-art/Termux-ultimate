#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Uninstaller
# Removes what Termux Ultimate installed. Packages are left untouched.

set -e

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

echo "================================="
echo " Termux Ultimate Uninstaller"
echo "================================="
echo

ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.termux-ultimate-backup"

if [ -f "$BACKUP" ]; then
    mv "$BACKUP" "$ZSHRC"
    echo "✓ Restored your original .zshrc"
elif [ -f "$ZSHRC" ] && grep -q "oh-my-zsh" "$ZSHRC" 2>/dev/null; then
    mv "$ZSHRC" "$HOME/.zshrc.termux-ultimate-removed"
    echo "✓ Kept the generated .zshrc at ~/.zshrc.termux-ultimate-removed"
else
    echo "• Left your .zshrc untouched (no Termux Ultimate backup found)"
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    rm -rf "$HOME/.oh-my-zsh"
    echo "✓ Removed Oh My Zsh"
else
    echo "• Oh My Zsh not found"
fi

if [ -d "$HOME/.termux-ultimate" ]; then
    rm -rf "$HOME/.termux-ultimate"
    echo "✓ Removed logs and state"
fi

echo
echo "Done. Packages (zsh, python, node, etc.) were left installed."
echo "Remove them with: pkg uninstall <package>"