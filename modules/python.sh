#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Python Module
# Python development environment

set -e

echo "================================="
echo " Termux Ultimate Python Installer"
echo "================================="

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

echo "[1/2] Installing Python..."

if ! command -v python >/dev/null 2>&1; then
    pkg install python -y
else
    echo "✓ python already installed"
fi

echo "[2/2] Setting up pip and dev tools..."

if command -v pip >/dev/null 2>&1; then
    pip install --upgrade pip
else
    python -m pip install --upgrade pip
fi

if ! command -v ipython >/dev/null 2>&1; then
    pip install ipython
else
    echo "✓ ipython already installed"
fi

echo
echo "✓ Python setup completed"
echo "Try it: python, ipython, pip"