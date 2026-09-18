#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Native Developer Tools Module
# Installs the toolchain used to build native projects in Termux.

set -e

echo "================================="
echo " Termux Ultimate Dev Tools Installer"
echo "================================="

START=$(date +%s)

if [ -z "${PREFIX:-}" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

echo "Installing native build tools..."
pkg install clang cmake make pkg-config -y

echo
echo "✓ Native developer tools installed"
echo "  clang:      $(clang --version 2>&1 | head -n 1)"
echo "  cmake:      $(cmake --version 2>&1 | head -n 1)"
echo "  make:       $(make --version 2>&1 | head -n 1)"
echo "  pkg-config: $(pkg-config --version 2>&1)"
echo "  elapsed:    $(($(date +%s) - START))s"