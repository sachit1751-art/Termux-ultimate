#!/data/data/com.termux/files/usr/bin/bash

set -e

ZSHRC="$HOME/.zshrc"
THEME_DIR="$HOME/.termux-ultimate/themes"
MODULE_THEMES="$(cd "$(dirname "$0")" && pwd)/themes"

echo "Configuring Zsh..."

if [ -f "$ZSHRC" ] && [ ! -f "$HOME/.zshrc.termux-ultimate-backup" ]; then
    cp "$ZSHRC" "$HOME/.zshrc.termux-ultimate-backup"
fi

cat > "$ZSHRC" <<'EOF'

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"


plugins=(
git
zsh-autosuggestions
zsh-syntax-highlighting
)


source $ZSH/oh-my-zsh.sh


alias ll='ls -lah'
alias l='ls -lh'
alias la='ls -A'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias home='cd ~'
alias md='mkdir -p'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --color=auto'
alias py='python'
alias srv='python -m http.server 8000'
alias tf='tail -f'
alias update='pkg update && pkg upgrade'


export EDITOR=nano


# Termux Ultimate greeting
greeting() {
    if command -v figlet >/dev/null 2>&1; then
        figlet -f slant "Termux Ultimate"
    else
        echo "🚀 Termux Ultimate"
    fi
    echo
    echo "  Welcome back, ${USER:-$(whoami)}! It's $(date '+%A, %d %B %Y')."
    echo "  Tip: run 'tu doctor' to check your setup, 'theme' to switch colors."
    echo
}

greeting
neofetch


# Termux Ultimate theme switcher: theme catppuccin | tokyonight | default
theme() {
    local name="${1:-}"
    case "$name" in
        catppuccin|tokyonight)
            cp "$HOME/.termux-ultimate/themes/$name.properties" "$HOME/.termux/colors.properties"
            command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings
            echo "Theme set to $name."
            ;;
        default)
            if [ -f "$HOME/.termux/colors.properties.bak" ]; then
                cp "$HOME/.termux/colors.properties.bak" "$HOME/.termux/colors.properties"
                command -v termux-reload-settings >/dev/null 2>&1 && termux-reload-settings
                echo "Theme restored to default."
            else
                rm -f "$HOME/.termux/colors.properties"
                echo "Theme restored to Termux default."
            fi
            ;;
        *)
            echo "Usage: theme catppuccin | tokyonight | default"
            ;;
    esac
}

EOF

echo "✓ .zshrc configured"

# Point 'tu' at this copy of Termux Ultimate
TU_CLI="$(cd "$(dirname "$0")/../.." && pwd)/tu"
if [ -f "$TU_CLI" ]; then
    {
        echo ""
        echo "# Point 'tu' at this copy of Termux Ultimate"
        echo "alias tu='$TU_CLI'"
    } >> "$ZSHRC"
fi

# Install theme files and apply Catppuccin by default
if [ -d "$MODULE_THEMES" ]; then
    mkdir -p "$THEME_DIR" "$HOME/.termux"

    if [ -f "$HOME/.termux/colors.properties" ] && [ ! -f "$HOME/.termux/colors.properties.bak" ]; then
        cp "$HOME/.termux/colors.properties" "$HOME/.termux/colors.properties.bak"
    fi

    cp "$MODULE_THEMES"/*.properties "$THEME_DIR/"
    cp "$THEME_DIR/catppuccin.properties" "$HOME/.termux/colors.properties"
    echo "✓ Applied Catppuccin theme (switch with: theme tokyonight)"
fi

chsh -s zsh 2>/dev/null || true