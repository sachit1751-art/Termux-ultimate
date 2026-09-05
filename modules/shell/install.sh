#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "[1/3] Updating packages..."

pkg update -y
pkg upgrade -y

PACKAGES="
zsh
git
curl
wget
nano
vim
openssh
figlet
neofetch
fastfetch
tmux
btop
htop
eza
bat
fd
ripgrep
jq
tldr
"

echo "[2/3] Installing packages..."

for package in $PACKAGES; do
    if ! command -v "$package" >/dev/null 2>&1; then
        pkg install "$package" -y
    else
        echo "✓ $package already installed"
    fi
done


echo "[3/3] Installing Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then

    RUNZSH=no \
    CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

else
    echo "✓ Oh My Zsh already installed"
fi
