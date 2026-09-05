#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - fastfetch configuration
# Theme-aware system info: uses the active terminal palette,
# so it follows whatever theme you switch to (theme catppuccin|tokyonight).

set -e

CONFIG_DIR="$HOME/.config/fastfetch"
CONFIG_FILE="$CONFIG_DIR/config.jsonc"

echo "Configuring fastfetch..."

mkdir -p "$CONFIG_DIR"

if [ -f "$CONFIG_FILE" ] && [ ! -f "$CONFIG_FILE.bak" ]; then
    cp "$CONFIG_FILE" "$CONFIG_FILE.bak"
fi

cat > "$CONFIG_FILE" <<'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "palette": "terminal",
  "display": {
    "separator": "  ",
    "color": {
      "keys": "blue",
      "title": "cyan"
    }
  },
  "logo": {
    "type": "auto",
    "color": {
      "range": {
        "light": { "from": 2, "to": 6 },
        "dark": { "from": 4, "to": 10 }
      }
    }
  },
  "modules": [
    { "type": "title", "color": { "title": "cyan" } },
    "os",
    "kernel",
    "uptime",
    "packages",
    "shell",
    "terminal",
    "cpu",
    "memory",
    "disk",
    "battery",
    "break",
    "colors",
    "break",
    "datetime"
  ]
}
EOF

echo "✓ fastfetch configured (uses the active theme palette)"