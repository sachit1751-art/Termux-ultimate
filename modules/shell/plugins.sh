#!/data/data/com.termux/files/usr/bin/bash

set -e

CUSTOM="$HOME/.oh-my-zsh/custom"

echo "Installing Zsh plugins..."

if [ ! -d "$CUSTOM/plugins/zsh-autosuggestions" ]; then
git clone https://github.com/zsh-users/zsh-autosuggestions \
"$CUSTOM/plugins/zsh-autosuggestions"
else
echo "✓ autosuggestions installed"
fi


if [ ! -d "$CUSTOM/plugins/zsh-syntax-highlighting" ]; then
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
"$CUSTOM/plugins/zsh-syntax-highlighting"
else
echo "✓ syntax-highlighting installed"
fi


if [ ! -d "$CUSTOM/themes/powerlevel10k" ]; then
git clone --depth=1 \
https://github.com/romkatv/powerlevel10k.git \
"$CUSTOM/themes/powerlevel10k"
else
echo "✓ Powerlevel10k installed"
fi
