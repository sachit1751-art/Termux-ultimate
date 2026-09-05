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


alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias home='cd ~'
alias md='mkdir -p'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias py='python'
alias srv='python -m http.server 8000'
alias tf='tail -f'
alias update='pkg update && pkg upgrade'


# Modern tool replacements (\ls, \cat, \grep, \find bypass them)
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first'
    alias ll='eza -lah --group-directories-first'
    alias l='eza -lh --group-directories-first'
    alias la='eza -A'
    alias tree='eza --tree'
else
    alias ll='ls -lah'
    alias l='ls -lh'
    alias la='ls -A'
fi

if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
fi

if command -v rg >/dev/null 2>&1; then
    alias grep='rg --color=auto'
else
    alias grep='grep --color=auto'
fi

if command -v fd >/dev/null 2>&1; then
    alias find='fd'
fi


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

if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
else
    neofetch
fi


# Termux Ultimate theme switcher: theme catppuccin | tokyonight | default
theme() {
    local name="${1:-}"
    case "$name" in
        catppuccin|tokyonight|dracula)
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
            echo "Usage: theme catppuccin | tokyonight | dracula | default"
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

# Tab completion for 'tu' (Oh My Zsh auto-loads custom/completions)
if [ -d "$HOME/.oh-my-zsh/custom" ]; then
    mkdir -p "$HOME/.oh-my-zsh/custom/completions"
    cat > "$HOME/.oh-my-zsh/custom/completions/_tu" <<'EOF'
#compdef tu
_tu() {
    if (( CURRENT == 2 )); then
        _values 'command' doctor repair update uninstall version install help
    elif (( CURRENT == 3 )); then
        case $words[2] in
            install) _values 'module' shell python node ai media ;;
            *) _message 'no more arguments' ;;
        esac
    else
        _message 'no more arguments'
    fi
}
compdef _tu tu
EOF
    echo "✓ Added tab completion for 'tu'"
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