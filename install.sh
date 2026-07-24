#!/data/data/com.termux/files/usr/bin/bash

set -Eeuo pipefail

PROJECT="Termux Ultimate"
VERSION="0.1.0-alpha"

LOG_DIR="$HOME/.termux-ultimate/logs"
LOG_FILE="$LOG_DIR/install.log"

mkdir -p "$LOG_DIR"

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
RESET="\033[0m"

print() {
    printf "${CYAN}==>${RESET} %s\n" "$1"
}

success() {
    printf "${GREEN}✓${RESET} %s\n" "$1"
}

warn() {
    printf "${YELLOW}!${RESET} %s\n" "$1"
}

error() {
    printf "${RED}✗${RESET} %s\n" "$1"
}

log() {
    echo "[$(date '+%F %T')] $1" >> "$LOG_FILE"
}

run() {
    print "$1"
    shift

    if "$@" >>"$LOG_FILE" 2>&1; then
        success "$1 completed"
    else
        error "$1 failed"
        exit 1
    fi
}

clear

echo
echo "==========================================="
echo "        🚀 $PROJECT"
echo "            $VERSION"
echo "==========================================="
echo

log "Installer started"

if ! command -v pkg >/dev/null; then
    error "This installer must be run inside Termux."
    exit 1
fi

print "Checking internet..."

if ping -c 1 github.com >/dev/null 2>&1; then
    success "Internet connection detected"
else
    error "No internet connection."
    exit 1
fi

run "Updating package lists" pkg update -y

run "Upgrading packages" pkg upgrade -y

success "Bootstrap completed."

echo
echo "Next versions will automatically install:"
echo
echo " • Oh My Zsh"
echo " • Powerlevel10k"
echo " • Fastfetch"
echo " • Ollama"
echo " • Gemini CLI"
echo " • Python environment"
echo " • Node.js environment"
echo " • Developer tools"
echo
echo "Installation log:"
echo "$LOG_FILE"
