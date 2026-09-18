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

if [ "${1:-}" = "--check" ]; then
    LOCAL_VERSION="$(cat "$ROOT/VERSION" 2>/dev/null || echo unknown)"
    REMOTE_VERSION="$(curl -fsSL https://raw.githubusercontent.com/sachit1751-art/Termux-ultimate/main/VERSION 2>/dev/null || true)"

    if [ -z "$REMOTE_VERSION" ]; then
        echo "Error: could not check the latest version."
        exit 1
    fi

    if [ "$LOCAL_VERSION" = "$REMOTE_VERSION" ]; then
        echo "✓ Termux Ultimate v$LOCAL_VERSION is up to date."
        exit 0
    fi

    echo "Update available: v$LOCAL_VERSION -> v$REMOTE_VERSION"
    echo "Run 'tu update' to install it."
    exit 0
fi

if [ ! -d "$ROOT/.git" ]; then
    echo "Error: this copy of Termux Ultimate is not a git repository."
    echo "Reinstall with the one-command installer instead:"
    echo "  curl -fsSL https://raw.githubusercontent.com/sachit1751-art/Termux-ultimate/main/install.sh | bash"
    exit 1
fi

EXPECTED_REMOTE="https://github.com/sachit1751-art/Termux-ultimate.git"
ACTUAL_REMOTE="$(git -C "$ROOT" config --get remote.origin.url 2>/dev/null || true)"
case "$ACTUAL_REMOTE" in
    "$EXPECTED_REMOTE"|git@github.com:sachit1751-art/Termux-ultimate.git) ;;
    *)
        echo "Error: unexpected repository remote: ${ACTUAL_REMOTE:-not configured}"
        exit 1
        ;;
esac

if ! git -C "$ROOT" diff --quiet || ! git -C "$ROOT" diff --cached --quiet; then
    echo "Error: local changes detected; commit or back them up before updating."
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