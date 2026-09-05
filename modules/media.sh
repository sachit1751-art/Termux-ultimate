#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - Media Module
# yt-dlp + FFmpeg for downloading and processing media

set -e

echo "================================="
echo " Termux Ultimate Media Installer"
echo "================================="

if [ -z "$PREFIX" ]; then
    echo "Error: This does not look like Termux."
    exit 1
fi

echo "[1/2] Installing yt-dlp..."

if ! command -v yt-dlp >/dev/null 2>&1; then
    pkg install yt-dlp -y
else
    echo "✓ yt-dlp already installed"
fi

echo "[2/2] Installing FFmpeg..."

if ! command -v ffmpeg >/dev/null 2>&1; then
    pkg install ffmpeg -y
else
    echo "✓ ffmpeg already installed"
fi

echo
echo "✓ Media setup completed"
echo "Download a video:    yt-dlp <url>"
echo "Convert a file:      ffmpeg -i input.mp4 output.mp3"