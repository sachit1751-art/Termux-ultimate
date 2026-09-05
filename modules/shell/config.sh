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
alias c='clear'
alias ..='cd ..'
alias home='cd ~'
alias update='pkg update && pkg upgrade'


export EDITOR=nano


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


neofetch

EOF

echo "✓ .zshrc configured"

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