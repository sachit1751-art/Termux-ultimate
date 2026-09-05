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

MODULES="shell python node ai media"

show_help() {
cat << EOF
Termux Ultimate v$VERSION

Run ./tu with no arguments for the interactive menu.

Usage:
  ./tu                       Interactive menu
  ./tu install <module>      Install a module
  ./tu doctor                Check your setup health
  ./tu repair                Reinstall anything that is missing
  ./tu update                Pull the latest version
  ./tu uninstall [module]    Remove the setup (or one module)
  ./tu backup                Back up your dotfiles
  ./tu restore <file>        Restore from a backup
  ./tu logs                  View the install log
  ./tu version               Show version

Modules:
  shell    Zsh + Oh My Zsh + Powerlevel10k
  python   Python development environment
  node     Node.js, pnpm, Yarn
  ai       Ollama + Gemini CLI
  media    yt-dlp + FFmpeg
EOF
}

run_doctor()    { bash "$ROOT/modules/doctor.sh"; }
run_repair()    { bash "$ROOT/modules/repair.sh"; }
run_update()    { bash "$ROOT/modules/update.sh"; }
run_uninstall() { bash "$ROOT/uninstall.sh"; }

show_logs() {
    local log_file="$HOME/.termux-ultimate/logs/install.log"
    if [ -f "$log_file" ]; then
        echo "=== $log_file (last 50 lines) ==="
        tail -n 50 "$log_file"
    else
        echo "No install log found yet - run 'tu install <module>' first."
    fi
}

describe_module() {
    case "$1" in
        shell)  echo "Zsh + Oh My Zsh + Powerlevel10k + tools" ;;
        python) echo "Python + pip + IPython + uv" ;;
        node)   echo "Node.js + npm + pnpm + Yarn" ;;
        ai)     echo "Ollama + Gemini CLI" ;;
        media)  echo "yt-dlp + FFmpeg" ;;
    esac
}

install_module() {
    local mod="$1"
    case " $MODULES " in
        *" $mod "*)
            bash "$ROOT/modules/$mod.sh"
            ;;
        *)
            echo "Unknown module: $mod"
            show_help
            ;;
    esac
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
                        if [ "$choice" -ge 1 ] && [ "$choice" -le 5 ]; then
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
        echo "  4) Update    - pull the latest version"
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
            4) run_update ;;
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
        echo "Termux Ultimate v$VERSION"
        ;;

    doctor)
        run_doctor
        ;;

    repair)
        run_repair
        ;;

    update)
        run_update
        ;;

    uninstall)
        if [ -n "$2" ]; then
            bash "$ROOT/modules/uninstall.sh" "$2"
        else
            run_uninstall
        fi
        ;;

    backup | restore)
        bash "$ROOT/modules/backup.sh" "$1" "${2:-}"
        ;;

    logs)
        show_logs
        ;;

    install)
        if [ -n "$2" ]; then
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
        show_help
        ;;

esac