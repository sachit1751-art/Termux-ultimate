#!/data/data/com.termux/files/usr/bin/bash

VERSION="0.1.0-alpha"
ROOT="$(cd "$(dirname "$0")" && pwd)"

show_help() {
cat << EOF
Termux Ultimate

Usage:
  ./tu install <module>
  ./tu doctor
  ./tu repair
  ./tu update
  ./tu version

Modules:
  shell
  python
  node
  ai
  media
EOF
}

case "$1" in
  version)
    echo "$VERSION"
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
  install)
    case "$2" in
      shell) bash "$ROOT/modules/shell.sh" ;;
      python) bash "$ROOT/modules/python.sh" ;;
      node) bash "$ROOT/modules/node.sh" ;;
      ai) bash "$ROOT/modules/ai.sh" ;;
      media) bash "$ROOT/modules/media.sh" ;;
      *) show_help ;;
    esac
    ;;
  *)
    show_help
    ;;
esac
