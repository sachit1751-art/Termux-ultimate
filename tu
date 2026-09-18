#!/data/data/com.termux/files/usr/bin/bash

# Resolve the real script path even when 'tu' is a symlink (e.g. $PREFIX/bin/tu)
SCRIPT="$0"
while [ -L "$SCRIPT" ]; do
    DIR="$(cd -P "$(dirname "$SCRIPT")" && pwd)"
    LINK="$(readlink "$SCRIPT")"
    case "$LINK" in
        /*) SCRIPT="$LINK" ;;
        *) SCRIPT="$DIR/$LINK" ;;
    esac
done
ROOT="$(cd -P "$(dirname "$SCRIPT")" && pwd)"
VERSION="$(cat "$ROOT/VERSION" 2>/dev/null || echo "unknown")"
# shellcheck source=modules/modules.conf
. "$ROOT/modules/modules.conf"
MODULE_COUNT="$(module_count)"

show_help() {
cat << EOF
Termux Ultimate v$VERSION

Run ./tu with no arguments for the interactive menu.

Usage:
  ./tu                       Interactive menu
  ./tu install <module>      Install a module
    ./tu install all           Install every module
    ./tu install shell,node    Install multiple modules
    ./tu install --dry-run all Preview module changes
  ./tu doctor                Check your setup health
    ./tu doctor --json         Print machine-readable health status
    ./tu status                Show installed module status
    ./tu status --json         Print module status as JSON
  ./tu repair                Reinstall anything that is missing
  ./tu update                Pull the latest version
  ./tu upgrade               Update + repair in one step
  ./tu uninstall [module]    Remove the setup (or one module)
  ./tu backup                Back up your dotfiles
  ./tu restore <file>        Restore from a backup
  ./tu logs                  View the install log
  ./tu env                   Show environment summary
    ./tu self-test             Run local regression checks
  ./tu version               Show version
    ./tu version --full        Show version and repository details
    ./tu version --json        Print version details as JSON
    ./tu project init <dir>    Create a minimal Git project scaffold

Modules:
  shell    Zsh + Oh My Zsh + Powerlevel10k
  python   Python development environment
  node     Node.js, pnpm, Yarn
  ai       Ollama + Gemini CLI
  media    yt-dlp + FFmpeg
  lazygit  Terminal UI for git
  lang     Rust + Go toolchains
    dev      Clang + CMake + Make + build tooling
EOF
}

run_doctor()    { bash "$ROOT/modules/doctor.sh" "${1:-}"; }
run_repair()    { bash "$ROOT/modules/repair.sh"; }
run_update()    { bash "$ROOT/modules/update.sh" "${1:-}"; }
run_uninstall() { bash "$ROOT/uninstall.sh"; }
run_upgrade()   { bash "$ROOT/modules/update.sh" && bash "$ROOT/modules/repair.sh"; }

show_logs() {
    local log_file="$HOME/.termux-ultimate/logs/install.log"
    local lines=50

    if [ "${1:-}" = "--tail" ]; then
        case "${2:-}" in
            '' | *[!0-9]*)
                echo "Usage: tu logs [--tail number]" >&2
                return 2
                ;;
            *) lines="$2" ;;
        esac
    fi

    if [ -f "$log_file" ]; then
        echo "=== $log_file (last $lines lines) ==="
        tail -n "$lines" "$log_file"
    else
        echo "No install log found yet - run 'tu install <module>' first."
    fi
}

show_status() {
    local mod
    local state
    local json="${1:-}"
    local first=1

    [ "$json" = "--json" ] || echo "Termux Ultimate module status"
    [ "$json" = "--json" ] && printf '{"modules":{'
    for mod in $MODULES; do
        state="missing"
        case "$mod" in
            shell) command -v zsh >/dev/null 2>&1 && [ -d "$HOME/.oh-my-zsh" ] && state="installed" ;;
            python) command -v python >/dev/null 2>&1 && state="installed" ;;
            node) command -v node >/dev/null 2>&1 && state="installed" ;;
            ai) command -v ollama >/dev/null 2>&1 && command -v gemini >/dev/null 2>&1 && state="installed" ;;
            media) command -v yt-dlp >/dev/null 2>&1 && command -v ffmpeg >/dev/null 2>&1 && state="installed" ;;
            lazygit) command -v lazygit >/dev/null 2>&1 && state="installed" ;;
            lang) command -v rustc >/dev/null 2>&1 && command -v go >/dev/null 2>&1 && state="installed" ;;
        esac
        if [ "$json" = "--json" ]; then
            [ "$first" -eq 1 ] || printf ','
            printf '"%s":{"state":"%s"}' "$mod" "$state"
            first=0
        else
            printf '  %-8s %s\n' "$mod" "$state"
        fi
    done
    [ "$json" = "--json" ] && printf '}}\n'
}

show_version() {
    local branch
    local commit
    local updated

    branch="$(git -C "$ROOT" branch --show-current 2>/dev/null || echo unknown)"
    commit="$(git -C "$ROOT" rev-parse --short HEAD 2>/dev/null || echo unknown)"
    updated="$(git -C "$ROOT" log -1 --format='%cs' 2>/dev/null || echo unknown)"

    if [ "${1:-}" = "--json" ]; then
        printf '{"version":"%s","root":"%s","branch":"%s","commit":"%s","updated":"%s"}\n' \
            "$VERSION" "$ROOT" "$branch" "$commit" "$updated"
    elif [ "${1:-}" = "--full" ]; then
        echo "Termux Ultimate v$VERSION"
        echo "  root:    $ROOT"
        echo "  branch:  $branch"
        echo "  commit:  $commit"
        echo "  updated: $updated"
    else
        echo "Termux Ultimate v$VERSION"
    fi
}

project_init() {
    local project_dir="${1:-}"

    if [ -z "$project_dir" ]; then
        echo "Usage: tu project init <directory>" >&2
        return 2
    fi
    if [ -e "$project_dir" ] && [ ! -d "$project_dir" ]; then
        echo "Error: path exists and is not a directory: $project_dir" >&2
        return 1
    fi
    if [ -d "$project_dir" ] && [ -n "$(find "$project_dir" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]; then
        echo "Error: project directory is not empty: $project_dir" >&2
        return 1
    fi

    mkdir -p "$project_dir"
    printf '# %s\n\nCreated with Termux Ultimate.\n' "$(basename "$project_dir")" > "$project_dir/README.md"
    printf '.env\n.venv/\nnode_modules/\n' > "$project_dir/.gitignore"
    git -C "$project_dir" init >/dev/null 2>&1 || true
    echo "✓ Project scaffold created: $project_dir"
}

install_modules() {
    local selection="$1"
    local dry_run="${2:-0}"
    local failed=0
    local mod
    local requested=()

    if [ "$selection" = "all" ]; then
        IFS=' ' read -ra requested <<< "$MODULES"
    else
        IFS=',' read -ra requested <<< "$selection"
    fi

    if [ "${#requested[@]}" -eq 0 ] || [ -z "${requested[0]}" ]; then
        echo "No modules specified." >&2
        return 2
    fi

    for mod in "${requested[@]}"; do
        mod="${mod// /}"
        case " $MODULES " in
            *" $mod "*)
                if [ "$dry_run" -eq 1 ]; then
                    echo "[DRY RUN] would install module: $mod"
                elif ! bash "$ROOT/modules/$mod.sh"; then
                    failed=1
                fi
                ;;
            *)
                echo "Unknown module: $mod" >&2
                failed=1
                ;;
        esac
    done

    return "$failed"
}

install_module() {
    install_modules "$1"
}

pick_module() {
    while true; do
        echo
        echo "Which module would you like to install?"
        i=1
        for m in $MODULES; do
            echo "  $i) $m - $(describe_module "$m")"
            i=$((i + 1))
        done
        echo "  all) install everything"
        echo "  0) back to menu"
        read -rp "> " choice

        case "$choice" in
            "" | 0) return ;;
            all)
                for m in $MODULES; do
                    install_module "$m"
                done
                return
                ;;
            *)
                case "$choice" in
                    *[!0-9]*)
                        echo "Invalid choice."
                        ;;
                    *)
                        if [ "$choice" -ge 1 ] && [ "$choice" -le "$MODULE_COUNT" ]; then
                            install_module "$(echo "$MODULES" | cut -d' ' -f"$choice")"
                        else
                            echo "Invalid choice."
                        fi
                        ;;
                esac
                ;;
        esac
    done
}

menu() {
    while true; do
        clear
        echo "==========================================="
        echo "        🚀 Termux Ultimate v$VERSION"
        echo "==========================================="
        echo
        echo "  1) Doctor    - check your setup"
        echo "  2) Repair    - fix missing components"
        echo "  3) Install   - add a module"
        echo "  4) Upgrade   - update + repair in one step"
        echo "  5) Uninstall - remove the setup"
        echo "  6) Backup    - save your dotfiles"
        echo "  7) Logs      - view the install log"
        echo "  8) Version"
        echo "  0) Exit"
        echo
        read -rp "> " choice

        case "$choice" in
            1) run_doctor ;;
            2) run_repair ;;
            3) pick_module ;;
            4) run_upgrade ;;
            5) run_uninstall; break ;;
            6) bash "$ROOT/modules/backup.sh" backup ;;
            7) show_logs ;;
            8) echo "Termux Ultimate v$VERSION" ;;
            0 | "") break ;;
            *) echo "Invalid choice." ;;
        esac

        echo
        read -rp "Press Enter to continue..." _ || true
    done
}

case "$1" in

    "" | menu)
        if [ -t 0 ]; then
            menu
        else
            show_help
        fi
        ;;

    version)
        show_version "${2:-}"
        ;;

    doctor)
        if [ "${2:-}" = "--quiet" ]; then
            run_doctor >/dev/null 2>&1
        else
            run_doctor "${2:-}"
        fi
        ;;

    repair)
        run_repair
        ;;

    update)
        run_update "${2:-}"
        ;;

    status)
        show_status "${2:-}"
        ;;

    project)
        if [ "${2:-}" = "init" ]; then
            project_init "${3:-}"
        else
            echo "Usage: tu project init <directory>" >&2
            exit 2
        fi
        ;;

    upgrade)
        run_upgrade
        ;;

    uninstall)
        if [ -n "$2" ]; then
            bash "$ROOT/modules/uninstall.sh" "$2" "${3:-}"
        else
            run_uninstall
        fi
        ;;

    backup)
        if [ "${2:-}" = "--list" ]; then
            bash "$ROOT/modules/backup.sh" --list "${3:-}"
        else
            bash "$ROOT/modules/backup.sh" backup "${2:-}"
        fi
        ;;

    restore)
        bash "$ROOT/modules/backup.sh" restore "${2:-}"
        ;;

    logs)
        show_logs "${2:-}" "${3:-}"
        ;;

    env)
        echo "Termux Ultimate environment"
        echo "  version:  v$VERSION"
        echo "  root:     $ROOT"
        echo "  prefix:   ${PREFIX:-not set}"
        echo "  home:     $HOME"
        echo "  shell:    ${SHELL:-unknown}"
        UP="$(uptime 2>/dev/null || true)"
        echo "  uptime:   ${UP:-n/a}"
        ;;

    self-test)
        if [ -f "$ROOT/tests/test.sh" ]; then
            bash "$ROOT/tests/test.sh"
        else
            echo "Error: regression test runner is missing." >&2
            exit 1
        fi
        ;;

    install)
        if [ "$2" = "--dry-run" ]; then
            if [ -n "$3" ]; then
                install_modules "$3" 1
            else
                echo "Usage: tu install --dry-run <module|all|module,module>" >&2
                exit 2
            fi
        elif [ -n "$2" ]; then
            install_module "$2"
        elif [ -t 0 ]; then
            pick_module
        else
            show_help
        fi
        ;;

    help | -h | --help)
        show_help
        ;;

    *)
        echo "Unknown command: $1" >&2
        show_help
        exit 2
        ;;

esac