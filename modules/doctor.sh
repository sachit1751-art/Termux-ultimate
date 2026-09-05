#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Doctor Module
# Checks that the environment and each module are healthy

FAILURES=0

check() {
    # check <label> <command>
    if command -v "$2" >/dev/null 2>&1 || [ -e "$2" ]; then
        echo "  [OK] $1"
    else
        echo "  [MISSING] $1"
        FAILURES=$((FAILURES + 1))
    fi
}

echo "================================="
echo " Termux Ultimate Doctor"
echo "================================="
echo

START=$(date +%s)

echo "Environment:"
if [ -n "$PREFIX" ]; then
    echo "  [OK] Termux detected (PREFIX=$PREFIX)"
else
    echo "  [MISSING] This does not look like Termux."
    FAILURES=$((FAILURES + 1))
fi

if ping -c 1 github.com >/dev/null 2>&1; then
    echo "  [OK] Internet connection"
else
    echo "  [MISSING] No internet connection"
    FAILURES=$((FAILURES + 1))
fi

LOCAL_VERSION="$(cat "$(cd "$(dirname "$0")/.." && pwd)/VERSION" 2>/dev/null || echo 'unknown')"
REMOTE_VERSION="$(curl -fsSL https://raw.githubusercontent.com/sachit1751-art/Termux-ultimate/main/VERSION 2>/dev/null || echo '')"
echo "  [INFO] local version: v$LOCAL_VERSION"
if [ -n "$REMOTE_VERSION" ] && [ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]; then
    echo "  [UPDATE] v$REMOTE_VERSION is available - run 'tu update'"
elif [ -n "$REMOTE_VERSION" ]; then
    echo "  [OK] up to date"
else
    echo "  [?] could not check for updates"
fi

check "package manager (pkg)" "pkg"
check "git" "git"

echo
echo "Shell module:"
check "zsh" "zsh"
check "Oh My Zsh" "$HOME/.oh-my-zsh/oh-my-zsh.sh"
check "Powerlevel10k" "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
check "zsh-autosuggestions" "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
check "zsh-syntax-highlighting" "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
check "fastfetch" "fastfetch"
check "eza" "eza"
check "bat" "bat"
check "fd" "fd"
check "ripgrep (rg)" "rg"

echo
echo "Python module:"
check "python" "python"
check "pip" "pip"
check "ipython" "ipython"

echo
echo "Node module:"
check "node" "node"
check "npm" "npm"
check "pnpm" "pnpm"
check "yarn" "yarn"

echo
echo "AI module:"
check "ollama" "ollama"
check "gemini" "gemini"

echo
echo "Media module:"
check "yt-dlp" "yt-dlp"
check "ffmpeg" "ffmpeg"

echo
if [ "$FAILURES" -eq 0 ]; then
    echo "✓ Everything looks good"
else
    echo "! $FAILURES item(s) missing - run ./tu repair to fix"
fi

echo "Completed in $(($(date +%s) - START))s"

if [ "$FAILURES" -gt 0 ]; then
    exit 1
fi
exit 0