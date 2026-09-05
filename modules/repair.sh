#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Repair Module
# Reinstalls any module whose key components are missing

set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "================================="
echo " Termux Ultimate Repair"
echo "================================="
echo

START=$(date +%s)

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

missing() {
    # missing <command>
    ! command -v "$1" >/dev/null 2>&1
}

if missing zsh || [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "! Shell setup missing, reinstalling..."
    bash "$ROOT/modules/shell.sh"
else
    echo "✓ Shell setup OK"
fi

if missing python; then
    echo "! Python missing, reinstalling..."
    bash "$ROOT/modules/python.sh"
else
    echo "✓ Python OK"
fi

if missing node; then
    echo "! Node missing, reinstalling..."
    bash "$ROOT/modules/node.sh"
else
    echo "✓ Node OK"
fi

if missing ollama && missing gemini; then
    echo "! AI tools missing, reinstalling..."
    bash "$ROOT/modules/ai.sh"
else
    echo "✓ AI tools OK"
fi

if missing yt-dlp; then
    echo "! Media tools missing, reinstalling..."
    bash "$ROOT/modules/media.sh"
else
    echo "✓ Media tools OK"
fi

if missing lazygit; then
    echo "! Lazygit missing, reinstalling..."
    bash "$ROOT/modules/lazygit.sh"
else
    echo "✓ Lazygit OK"
fi

if missing rustc || missing go; then
    echo "! Language toolchains missing, reinstalling..."
    bash "$ROOT/modules/lang.sh"
else
    echo "✓ Lang toolchains OK"
fi

echo
echo "✓ Repair completed"
echo "  elapsed: $(($(date +%s) - START))s"
echo
echo "Run './tu doctor' to verify everything."