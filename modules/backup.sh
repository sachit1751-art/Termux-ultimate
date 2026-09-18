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

    if ! tar -tzf "$file" >/dev/null 2>&1; then
        echo "Error: invalid or unreadable backup archive: $file"
        exit 1
    fi

    while IFS= read -r entry; do
        case "$entry" in
            /* | ../* | */../* | ..)
                echo "Error: unsafe path in backup archive: $entry"
                exit 1
                ;;
        esac
    done < <(tar -tzf "$file")

    # Protect against overwriting the current state
    do_backup "$BACKUP_DIR/pre-restore-$(date '+%Y%m%d-%H%M%S').tar.gz" || true

    tar -xzf "$file" -C "$HOME"
    echo "✓ Restored from: $file"
    echo "  Restart your shell (or run 'zsh') to apply."
}

list_backups() {
    local json=0
    local file
    local escaped_file
    local first=1

    [ "${1:-}" = "--json" ] && json=1

    if [ ! -d "$BACKUP_DIR" ]; then
        if [ "$json" -eq 1 ]; then
            echo '{"backups":[]}'
        else
            echo "No backups found."
        fi
        return 0
    fi

    if [ "$json" -eq 1 ]; then
        printf '{"backups":['
        while IFS= read -r file; do
            [ "$first" -eq 1 ] || printf ','
            escaped_file="$(printf '%s' "$file" | sed 's/\\/\\\\/g; s/"/\\"/g')"
            printf '"%s"' "$escaped_file"
            first=0
        done < <(find "$BACKUP_DIR" -maxdepth 1 -type f -name '*.tar.gz' -printf '%f\n' | sort)
        printf ']}\n'
    else
        find "$BACKUP_DIR" -maxdepth 1 -type f -name '*.tar.gz' -printf '%f\n' | sort
    fi
}

case "${1:-}" in
    backup)
        do_backup "${2:-}"
        ;;
    restore)
        do_restore "${2:-}"
        ;;
    --list)
        list_backups "${2:-}"
        ;;
    *)
        echo "Usage: tu backup [dest-file] | tu backup --list | tu restore <file>"
        exit 1
        ;;
esac