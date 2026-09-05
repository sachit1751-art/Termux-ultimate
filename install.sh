#!/data/data/com.termux/files/usr/bin/bash

set -Eeuo pipefail

PROJECT="Termux Ultimate"
REPO_URL="https://github.com/sachit1751-art/Termux-ultimate.git"
INSTALL_DIR="$HOME/.termux-ultimate"
LOG_DIR="$INSTALL_DIR/logs"
LOG_FILE="$LOG_DIR/install.log"

VERSION="$(curl -fsSL https://raw.githubusercontent.com/sachit1751-art/Termux-ultimate/main/VERSION 2>/dev/null || echo "0.1.1")"

MODULES="shell python node ai media"

describe_module() {
    case "$1" in
        shell)  echo "Zsh + Oh My Zsh + Powerlevel10k + tools" ;;
        python) echo "Python + pip + IPython + uv" ;;
        node)   echo "Node.js + npm + pnpm + Yarn" ;;
        ai)     echo "Ollama + Gemini CLI" ;;
        media)  echo "yt-dlp + FFmpeg" ;;
    esac
}

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
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
    mkdir -p "$LOG_DIR"
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

log "Installer started (version $VERSION)"

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

if ! command -v git >/dev/null 2>&1; then
    run "Installing git" pkg install git -y
else
    success "git already installed"
fi

success "Bootstrap completed."

echo
print "Setting up $PROJECT in $INSTALL_DIR..."

if [ -d "$INSTALL_DIR/.git" ]; then
    print "Already installed, pulling latest changes..."
    if git -C "$INSTALL_DIR" pull --ff-only origin main; then
        success "Updated to latest version"
    else
        error "Update failed (uncommitted local changes?)."
        exit 1
    fi
elif [ -d "$INSTALL_DIR" ]; then
    if [ "$(find "$INSTALL_DIR" -mindepth 1 -maxdepth 1 | wc -l)" -eq 0 ]; then
        run "Cloning $PROJECT" git clone "$REPO_URL" "$INSTALL_DIR"
    elif [ -d "$INSTALL_DIR/logs" ] && [ "$(find "$INSTALL_DIR" -mindepth 1 ! -path "$INSTALL_DIR/logs*" | wc -l)" -eq 0 ]; then
        # Leftover logs from a previous bootstrap-only run; safe to replace.
        rm -rf "$INSTALL_DIR/logs"
        run "Cloning $PROJECT" git clone "$REPO_URL" "$INSTALL_DIR"
    else
        error "$INSTALL_DIR exists and does not look like a Termux Ultimate install."
        exit 1
    fi
else
    run "Cloning $PROJECT" git clone "$REPO_URL" "$INSTALL_DIR"
fi

log "Repository ready at $INSTALL_DIR"

# Make 'tu' available anywhere
if [ -w "$PREFIX/bin" ]; then
    ln -sf "$INSTALL_DIR/tu" "$PREFIX/bin/tu"
    success "Added 'tu' to PATH"
else
    warn "Could not add 'tu' to PATH - use $INSTALL_DIR/tu"
fi

# Request storage access (Android permission dialog on first run)
if command -v termux-setup-storage >/dev/null 2>&1; then
    if termux-setup-storage >/dev/null 2>&1; then
        success "Storage access granted"
    else
        warn "Storage access not granted - you can run termux-setup-storage later"
    fi
fi

# --- Module selection -------------------------------------------------------

selected=""

if [ $# -gt 0 ]; then
    # Modules passed as arguments: install.sh shell python
    for mod in "$@"; do
        case " $MODULES " in
            *" $mod "*)
                selected="$selected $mod"
                ;;
            *)
                warn "Unknown module: $mod (skipped)"
                ;;
        esac
    done
elif [ -t 0 ]; then
    # Interactive terminal: prompt for modules
    while true; do
        echo
        echo "Which modules should I install? (comma-separated numbers, e.g. 1,3,5)"
        echo "  0) none"
        i=1
        for mod in $MODULES; do
            echo "  $i) $mod - $(describe_module "$mod")"
            i=$((i + 1))
        done
        read -rp "> " choice

        if [ "$choice" = "all" ]; then
            selected="$MODULES"
            break
        fi

        if [ "$choice" = "none" ] || [ -z "$choice" ]; then
            selected=""
            break
        fi

        valid=1
        new_selected=""
        IFS=',' read -ra parts <<< "$choice"
        for part in "${parts[@]}"; do
            part="${part// /}"
            case "$part" in
                '' | *[!0-9]*)
                    valid=0
                    ;;
                *)
                    if [ "$part" -ge 1 ] && [ "$part" -le 5 ]; then
                        mod="$(echo "$MODULES" | cut -d' ' -f"$part")"
                        case " $new_selected " in
                            *" $mod "*) ;;
                            *) new_selected="$new_selected $mod" ;;
                        esac
                    else
                        valid=0
                    fi
                    ;;
            esac
        done

        if [ "$valid" -eq 1 ]; then
            selected="$new_selected"
            break
        fi
        warn "Invalid selection, try again."
    done
else
    # Piped (curl | bash): no terminal to prompt. Pass modules as arguments, e.g.
    #   bash install.sh shell python
    echo
    warn "No terminal detected - skipping the module prompt."
    warn "Re-run interactively, or pass modules as arguments:"
    warn "  bash install.sh shell python node ai media"
fi

# --- Install selected modules -----------------------------------------------

if [ -n "$selected" ]; then
    echo
    print "Installing modules:$selected"

    for mod in $selected; do
        log "Installing module: $mod"
        if bash "$INSTALL_DIR/modules/$mod.sh"; then
            success "Module '$mod' installed"
        else
            error "Module '$mod' failed"
        fi
    done
else
    echo
    warn "No modules selected."
fi

echo
success "Setup completed."
echo
echo "Your CLI is available at:"
echo "  $INSTALL_DIR/tu"
echo
echo "Quick start:"
echo "  $INSTALL_DIR/tu doctor"
echo "  $INSTALL_DIR/tu install shell"
echo "  $INSTALL_DIR/tu update"
echo
echo "Installation log:"
echo "  $LOG_FILE"