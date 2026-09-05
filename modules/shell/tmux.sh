#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - tmux configuration

set -e

TMUX_CONF="$HOME/.tmux.conf"

echo "Configuring tmux..."

if [ -f "$TMUX_CONF" ] && [ ! -f "$HOME/.tmux.conf.termux-ultimate-backup" ]; then
    cp "$TMUX_CONF" "$HOME/.tmux.conf.termux-ultimate-backup"
fi

cat > "$TMUX_CONF" <<'EOF'
# Termux Ultimate tmux configuration

set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# Mouse and history
set -g mouse on
set -g history-limit 10000

# 1-based numbering
set -g base-index 1
setw -g pane-base-index 1

# vi-style copy mode
setw -g mode-keys vi
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

# Split panes in the current directory
bind - split-window -v -c "#{pane_current_path}"
bind | split-window -h -c "#{pane_current_path}"

# Status bar (Tokyo Night palette)
set -g status-style "bg=#1a1b26,fg=#a9b1d6"
set -g window-status-current-style "fg=#7aa2f7,bold"
set -g status-left "#[fg=#7aa2f7]Termux #[default]"
set -g status-right "#[fg=#a9b1d6]%H:%M #[default]"
EOF

echo "✓ .tmux.conf configured"