#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Python Module
# Python development environment

set -e

echo "================================="
echo " Termux Ultimate Python Installer"
echo "================================="

START=$(date +%s)

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

echo "[1/3] Installing Python..."

if ! command -v python >/dev/null 2>&1; then
    pkg install python -y
else
    echo "✓ python already installed"
fi

echo "[2/3] Setting up pip and dev tools..."

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

echo "[3/3] Installing uv (fast package & venv manager)..."

if ! command -v uv >/dev/null 2>&1; then
    pip install uv
else
    echo "✓ uv already installed"
fi

echo
echo "✓ Python setup completed"
echo "  python:  $(python --version 2>&1)"
echo "  pip:     $(pip --version 2>&1 | cut -d' ' -f1-2)"
echo "  ipython: $(command -v ipython >/dev/null 2>&1 && echo installed || echo 'not found')"
echo "  uv:      $(command -v uv >/dev/null 2>&1 && uv --version 2>&1 || echo 'not found')"
echo "  elapsed: $(($(date +%s) - START))s"
echo
echo "Try it: python, ipython, uv"