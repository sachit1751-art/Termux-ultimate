#!/data/data/com.termux/files/usr/bin/bash

ROOT="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(cat "$ROOT/VERSION" 2>/dev/null || echo "unknown")"

show_help() {
cat << EOF
Termux Ultimate v$VERSION

Usage:
  ./tu install <module>   Install a module
  ./tu doctor             Check your setup health
  ./tu repair             Reinstall anything that is missing
  ./tu update             Pull the latest version
  ./tu uninstall          Remove Termux Ultimate setup
  ./tu version            Show version

Modules:
  shell    Zsh + Oh My Zsh + Powerlevel10k
  python   Python development environment
  node     Node.js, pnpm, Yarn
  ai       Ollama + Gemini CLI
  media    yt-dlp + FFmpeg
EOF
}

case "$1" in

  version)
    echo "Termux Ultimate v$VERSION"
    ;;

  doctor)
    bash "$ROOT/modules/doctor.sh"
    ;;

  repair)
    bash "$ROOT/modules/repair.sh"
    ;;

  update)
    bash "$ROOT/modules/update.sh"
    ;;

  uninstall)
    bash "$ROOT/uninstall.sh"
    ;;

  install)
    case "$2" in
      shell)
        bash "$ROOT/modules/shell.sh"
        ;;
      python)
        bash "$ROOT/modules/python.sh"
        ;;
      node)
        bash "$ROOT/modules/node.sh"
        ;;
      ai)
        bash "$ROOT/modules/ai.sh"
        ;;
      media)
        bash "$ROOT/modules/media.sh"
        ;;
      *)
        show_help
        ;;
    esac
    ;;

  *)
    show_help
    ;;

esac