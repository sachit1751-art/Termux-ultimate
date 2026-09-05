#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Backup & Restore
# Backs up your dotfiles and Termux Ultimate state to a tarball.

set -e

BACKUP_DIR="$HOME/.termux-ultimate/backups"

# Files that make up a Termux Ultimate setup (paths relative to $HOME)
DOTFILES=".zshrc .zshrc.termux-ultimate-backup .zshrc.termux-ultimate-removed .tmux.conf .tmux.conf.termux-ultimate-backup .gitconfig .termux/colors.properties .termux/colors.properties.bak .oh-my-zsh/custom"

collect_files() {
    local list=""
    for f in $DOTFILES; do
        if [ -e "$HOME/$f" ]; then
            list="$list $f"
        fi
    done
    echo "$list"
}

do_backup() {
    local dest="${1:-$BACKUP_DIR/tu-backup-$(date '+%Y%m%d-%H%M%S').tar.gz}"
    local files
    files="$(collect_files)"

    if [ -z "$files" ]; then
        echo "Nothing to back up yet - install something first."
        return 1
    fi

    mkdir -p "$BACKUP_DIR"
    # shellcheck disable=SC2086
    tar -czf "$dest" -C "$HOME" $files
    echo "✓ Backup saved to: $dest"
}

do_restore() {
    local file="${1:-}"

    if [ -z "$file" ] || [ ! -f "$file" ]; then
        echo "Usage: tu restore <backup-file>"
        echo "Backups live in: $BACKUP_DIR"
        exit 1
    fi

    # Protect against overwriting the current state
    do_backup "$BACKUP_DIR/pre-restore-$(date '+%Y%m%d-%H%M%S').tar.gz" || true

    tar -xzf "$file" -C "$HOME"
    echo "✓ Restored from: $file"
    echo "  Restart your shell (or run 'zsh') to apply."
}

case "${1:-}" in
    backup)
        do_backup "${2:-}"
        ;;
    restore)
        do_restore "${2:-}"
        ;;
    *)
        echo "Usage: tu backup [dest-file] | tu restore <file>"
        exit 1
        ;;
esac