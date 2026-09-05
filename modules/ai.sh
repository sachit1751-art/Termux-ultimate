#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - AI Module
# Ollama (local LLMs) + Google Gemini CLI

set -e

echo "================================="
echo " Termux Ultimate AI Installer"
echo "================================="

START=$(date +%s)

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

echo "[1/3] Installing Ollama..."

if ! command -v ollama >/dev/null 2>&1; then
    pkg install ollama -y
else
    echo "✓ ollama already installed"
fi

echo "[2/3] Checking Node.js (required for Gemini CLI)..."

if ! command -v npm >/dev/null 2>&1; then
    echo "! npm not found, installing Node.js..."
    pkg install nodejs-lts -y
else
    echo "✓ npm already installed"
fi

echo "[3/3] Installing Gemini CLI..."

if ! command -v gemini >/dev/null 2>&1; then
    npm install -g @google/gemini-cli
else
    echo "✓ gemini already installed"
fi

echo
echo "✓ AI setup completed"
echo "  ollama: $(command -v ollama >/dev/null 2>&1 && ollama --version 2>&1 || echo 'not found')"
echo "  gemini: $(command -v gemini >/dev/null 2>&1 && echo installed || echo 'not found')"
echo "  elapsed: $(($(date +%s) - START))s"
echo
echo "Run local models:    ollama run <model>  (e.g. llama3.2)"
echo "Use Gemini CLI:      gemini"
echo "Note: Gemini CLI needs a Google API key on first run."