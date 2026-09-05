#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Node Module
# Node.js development environment: Node, npm, pnpm, Yarn

set -e

echo "================================="
echo " Termux Ultimate Node Installer"
echo "================================="

START=$(date +%s)

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

echo "[1/2] Installing Node.js..."

if ! command -v node >/dev/null 2>&1; then
    pkg install nodejs-lts -y
else
    echo "✓ node already installed"
fi

echo "[2/2] Installing pnpm and Yarn..."

if ! command -v pnpm >/dev/null 2>&1; then
    npm install -g pnpm
else
    echo "✓ pnpm already installed"
fi

if ! command -v yarn >/dev/null 2>&1; then
    npm install -g yarn
else
    echo "✓ yarn already installed"
fi

echo
echo "✓ Node setup completed"
echo "  node:  $(node -v 2>&1)"
echo "  npm:   $(npm -v 2>&1)"
echo "  pnpm:  $(pnpm -v 2>&1)"
echo "  yarn:  $(yarn -v 2>&1)"
echo "  elapsed: $(($(date +%s) - START))s"