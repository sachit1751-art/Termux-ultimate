#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Update Module
# Pulls the latest version of Termux Ultimate

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "================================="
echo " Termux Ultimate Updater"
echo "================================="
echo

START=$(date +%s)

if [ ! -d "$ROOT/.git" ]; then
    echo "Error: this copy of Termux Ultimate is not a git repository."
    echo "Reinstall with the one-command installer instead:"
    echo "  curl -fsSL https://raw.githubusercontent.com/sachit1751-art/Termux-ultimate/main/install.sh | bash"
    exit 1
fi

echo "Pulling latest changes..."

if git -C "$ROOT" pull --ff-only origin main; then
    echo "✓ Updated to $(cat "$ROOT/VERSION" 2>/dev/null || echo 'latest')"
else
    echo "! Update failed (uncommitted local changes?)."
    exit 1
fi

echo
echo "Run './tu doctor' to check your setup and './tu repair' to reinstall anything missing."
echo "Completed in $(($(date +%s) - START))s"