#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Lang Module
# Rust and Go toolchains

set -e

echo "================================="
echo " Termux Ultimate Lang Installer"
echo "================================="

START=$(date +%s)

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

echo "[1/2] Installing Rust..."

if ! command -v cargo >/dev/null 2>&1; then
    pkg install rust -y
else
    echo "✓ rust/cargo already installed"
fi

echo "[2/2] Installing Go..."

if ! command -v go >/dev/null 2>&1; then
    pkg install golang -y
else
    echo "✓ go already installed"
fi

echo
echo "✓ Lang setup completed"
echo "  rust:    $(command -v rustc >/dev/null 2>&1 && rustc --version 2>&1 || echo 'not found')"
echo "  go:      $(command -v go >/dev/null 2>&1 && go version 2>&1 || echo 'not found')"
echo "  elapsed: $(($(date +%s) - START))s"
echo
echo "Try it: cargo new hello && cd hello && cargo run"