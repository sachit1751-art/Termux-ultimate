#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Per-module uninstaller
# Removes what a single module installed. Use 'tu uninstall' (no module)
# for the full uninstaller.

set -e

MODULE="${1:-}"

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

if [ -z "$MODULE" ]; then
    echo "Usage: tu uninstall <module>"
    echo "Modules: shell python node ai media"
    exit 1
fi

echo "================================="
echo " Uninstalling module: $MODULE"
echo "================================="
echo

case "$MODULE" in

    shell)
        if [ -f "$HOME/.zshrc.termux-ultimate-backup" ]; then
            mv "$HOME/.zshrc.termux-ultimate-backup" "$HOME/.zshrc"
            echo "✓ Restored your original .zshrc"
        elif [ -f "$HOME/.zshrc" ] && grep -q "oh-my-zsh" "$HOME/.zshrc" 2>/dev/null; then
            mv "$HOME/.zshrc" "$HOME/.zshrc.termux-ultimate-removed"
            echo "✓ Kept the generated .zshrc at ~/.zshrc.termux-ultimate-removed"
        fi

        if [ -f "$HOME/.tmux.conf.termux-ultimate-backup" ]; then
            mv "$HOME/.tmux.conf.termux-ultimate-backup" "$HOME/.tmux.conf"
            echo "✓ Restored your original .tmux.conf"
        fi

        if [ -d "$HOME/.oh-my-zsh" ]; then
            rm -rf "$HOME/.oh-my-zsh"
            echo "✓ Removed Oh My Zsh"
        fi

        rm -f "$HOME/.termux-ultimate/themes/"*.properties 2>/dev/null || true
        echo "  Theme files removed (your colors.properties was left alone)"
        echo "  Packages left installed. Remove them with:"
        echo "  pkg uninstall zsh git curl wget nano vim openssh figlet neofetch fastfetch tmux btop htop eza bat fd ripgrep jq tldr"
        ;;

    python)
        pkg uninstall -y python 2>/dev/null || true
        command -v pip >/dev/null 2>&1 && pip uninstall -y ipython 2>/dev/null || true
        echo "✓ Python module removed (pip, ipython)"
        ;;

    node)
        npm uninstall -g pnpm yarn 2>/dev/null || true
        pkg uninstall -y nodejs-lts 2>/dev/null || true
        echo "✓ Node module removed (nodejs, pnpm, yarn)"
        ;;

    ai)
        pkg uninstall -y ollama 2>/dev/null || true
        npm uninstall -g @google/gemini-cli 2>/dev/null || true
        echo "✓ AI module removed (ollama, gemini)"
        ;;

    media)
        pkg uninstall -y yt-dlp ffmpeg 2>/dev/null || true
        echo "✓ Media module removed (yt-dlp, ffmpeg)"
        ;;

    *)
        echo "Unknown module: $MODULE"
        echo "Modules: shell python node ai media"
        exit 1
        ;;

esac

echo
echo "Done. Run 'tu doctor' to check what remains."