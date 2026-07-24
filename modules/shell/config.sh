#!/data/data/com.termux/files/usr/bin/bash

set -e

ZSHRC="$HOME/.zshrc"

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


neofetch

EOF


echo "✓ .zshrc configured"


chsh -s zsh 2>/dev/null || true
