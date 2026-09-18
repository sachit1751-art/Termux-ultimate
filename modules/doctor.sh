#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Doctor Module
# Checks that the environment and each module are healthy

JSON_MODE=0
if [ "${1:-}" = "--json" ]; then
    JSON_MODE=1
fi

json_escape() {
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

doctor_json() {
    local checks=""
    local failures=0
    local local_version
    local remote_version

    add_json_check() {
        local label="$1"
        local ok="$2"
        [ -n "$checks" ] && checks="$checks,"
        checks="$checks{\"name\":\"$(json_escape "$label")\",\"ok\":$ok}"
        [ "$ok" = true ] || failures=$((failures + 1))
    }

    if [ -n "${PREFIX:-}" ]; then
        add_json_check "Termux" true
    else
        add_json_check "Termux" false
    fi
    if ping -c 1 github.com >/dev/null 2>&1; then
        add_json_check "Internet connection" true
    else
        add_json_check "Internet connection" false
    fi

    local_version="$(cat "$(cd "$(dirname "$0")/.." && pwd)/VERSION" 2>/dev/null || echo unknown)"
    remote_version="$(curl -fsSL https://raw.githubusercontent.com/sachit1751-art/Termux-ultimate/main/VERSION 2>/dev/null || true)"
    add_json_check "package manager (pkg)" "$(command -v pkg >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "git" "$(command -v git >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "zsh" "$(command -v zsh >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "Oh My Zsh" "$([ -e "$HOME/.oh-my-zsh/oh-my-zsh.sh" ] && echo true || echo false)"
    add_json_check "python" "$(command -v python >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "node" "$(command -v node >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "ollama" "$(command -v ollama >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "gemini" "$(command -v gemini >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "yt-dlp" "$(command -v yt-dlp >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "ffmpeg" "$(command -v ffmpeg >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "lazygit" "$(command -v lazygit >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "rustc" "$(command -v rustc >/dev/null 2>&1 && echo true || echo false)"
    add_json_check "go" "$(command -v go >/dev/null 2>&1 && echo true || echo false)"

    printf '{"local_version":"%s","remote_version":"%s","failures":%s,"checks":[%s]}\n' \
        "$(json_escape "$local_version")" "$(json_escape "$remote_version")" "$failures" "$checks"
    [ "$failures" -eq 0 ]
}

if [ "$JSON_MODE" -eq 1 ]; then
    doctor_json
    exit $?
fi

FAILURES=0
SUGGESTIONS=()

check() {
    # check <label> <command-or-path> [suggestion]
    if command -v "$2" >/dev/null 2>&1 || [ -e "$2" ]; then
        echo "  [OK] $1"
    else
        echo "  [MISSING] $1"
        FAILURES=$((FAILURES + 1))
        local suggestion="${3:-tu repair}"
        local found=0
        for s in "${SUGGESTIONS[@]}"; do
            [ "$s" = "$suggestion" ] && found=1
        done
        [ "$found" -eq 0 ] && SUGGESTIONS+=("$suggestion")
    fi
}

echo "================================="
echo " Termux Ultimate Doctor"
echo "================================="
echo

START=$(date +%s)

echo "Environment:"
if [ -n "$PREFIX" ]; then
    echo "  [OK] Termux detected (PREFIX=$PREFIX)"
else
    echo "  [MISSING] This does not look like Termux."
    FAILURES=$((FAILURES + 1))
fi

if ping -c 1 github.com >/dev/null 2>&1; then
    echo "  [OK] Internet connection"
else
    echo "  [MISSING] No internet connection"
    FAILURES=$((FAILURES + 1))
fi

LOCAL_VERSION="$(cat "$(cd "$(dirname "$0")/.." && pwd)/VERSION" 2>/dev/null || echo 'unknown')"
REMOTE_VERSION="$(curl -fsSL https://raw.githubusercontent.com/sachit1751-art/Termux-ultimate/main/VERSION 2>/dev/null || echo '')"
echo "  [INFO] local version: v$LOCAL_VERSION"
if [ -n "$REMOTE_VERSION" ] && [ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]; then
    echo "  [UPDATE] v$REMOTE_VERSION is available - run 'tu update'"
elif [ -n "$REMOTE_VERSION" ]; then
    echo "  [OK] up to date"
else
    echo "  [?] could not check for updates"
fi

check "package manager (pkg)" "pkg"
check "git" "git" "pkg install git"

echo
echo "Shell module:"
check "zsh" "zsh" "tu install shell"
check "Oh My Zsh" "$HOME/.oh-my-zsh/oh-my-zsh.sh" "tu install shell"
check "Powerlevel10k" "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" "tu install shell"
check "zsh-autosuggestions" "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" "tu install shell"
check "zsh-syntax-highlighting" "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" "tu install shell"
check "fastfetch" "fastfetch" "tu install shell"
check "eza" "eza" "tu install shell"
check "bat" "bat" "tu install shell"
check "fd" "fd" "tu install shell"
check "ripgrep (rg)" "rg" "tu install shell"
check "jq" "jq" "tu install shell"
check "tldr" "tldr" "tu install shell"
check "termux-api" "termux-api" "tu install shell"

echo
echo "Python module:"
check "python" "python" "tu install python"
check "pip" "pip" "tu install python"
check "ipython" "ipython" "tu install python"
check "uv" "uv" "tu install python"

echo
echo "Node module:"
check "node" "node" "tu install node"
check "npm" "npm" "tu install node"
check "pnpm" "pnpm" "tu install node"
check "yarn" "yarn" "tu install node"

echo
echo "AI module:"
check "ollama" "ollama" "tu install ai"
check "gemini" "gemini" "tu install ai"

echo
echo "Media module:"
check "yt-dlp" "yt-dlp" "tu install media"
check "ffmpeg" "ffmpeg" "tu install media"

echo
echo "Lazygit module:"
check "lazygit" "lazygit" "tu install lazygit"

echo
echo "Lang module:"
check "rustc" "rustc" "tu install lang"
check "cargo" "cargo" "tu install lang"
check "go" "go" "tu install lang"

echo
echo "Dev tools module:"
check "clang" "clang" "tu install dev"
check "cmake" "cmake" "tu install dev"
check "make" "make" "tu install dev"
check "pkg-config" "pkg-config" "tu install dev"

echo
if [ "$FAILURES" -eq 0 ]; then
    echo "✓ Everything looks good"
else
    echo "! $FAILURES item(s) missing"
    echo
    echo "Suggested fixes:"
    for s in "${SUGGESTIONS[@]}"; do
        echo "  • $s"
    done
fi

echo "Completed in $(($(date +%s) - START))s"

if [ "$FAILURES" -gt 0 ]; then
    exit 1
fi
exit 0