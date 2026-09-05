# Termux Ultimate — End-to-End Test Checklist

Run this once on a real phone (or Termux in an Android emulator) to verify
everything works. Each step lists the command and the expected result.
Check the box when it passes.

> 💡 Start from a **fresh Termux install** (clear app data) for the most
> realistic run, then reinstall the app data once for the re-run tests.

## 1. One-command installer

- [ ] `curl -fsSL https://raw.githubusercontent.com/sachit1751-art/Termux-ultimate/main/install.sh | bash`
      shows the banner and "Bootstrap completed" with no `\r` or
      `command not found` errors.
- [ ] It asks "Which modules should I install?" — enter `1,2,3` and press Enter.
- [ ] All three modules (shell, python, node) install and print their
      summaries with versions and elapsed time.

## 2. Interactive menu

- [ ] `tu` opens the menu (Doctor / Repair / Install / Update / Uninstall /
      Backup / Version / Exit).
- [ ] Select **1 (Doctor)** — shows `[OK]` rows and ends with "Everything looks good".
- [ ] Select **6 (Backup)** — creates a `tu-backup-*.tar.gz` in `~/.termux-ultimate/backups`.
- [ ] Select **0 (Exit)** — leaves the menu cleanly.

## 3. Module install / uninstall

- [ ] `tu install ai` installs Ollama and Gemini CLI.
- [ ] `tu install media` installs yt-dlp and FFmpeg.
- [ ] `tu uninstall media` removes them again (`tu doctor` no longer lists yt-dlp/ffmpeg).
- [ ] `tu install` (no module) opens the module picker; pick `all` — everything
      installs.

## 4. Shell experience

- [ ] `zsh` starts with the figlet greeting, then fastfetch with themed colors.
- [ ] `theme tokyonight` switches colors (run `termux-reload-settings` hint appears),
      `theme catppuccin` switches back.
- [ ] `ls` is eza-style (colors, directories first), `cat` is bat, `grep` is rg,
      `find` is fd.
- [ ] `tu <TAB>` completes commands; `tu install <TAB>` completes modules.
- [ ] `tmux` opens with mouse support and the Tokyo Night status bar.
- [ ] `git lg` shows a nice log; `git st` is short status.

## 5. Self-update / repair

- [ ] `tu update` pulls latest changes and reports the new version.
- [ ] Remove something manually (e.g. `pkg uninstall fastfetch`) then
      `tu repair` — it reinstalls the missing piece.
- [ ] `tu doctor` reports `[UPDATE]` when the remote version is newer than local.

## 6. Backup & restore

- [ ] `tu backup` creates a tarball in `~/.termux-ultimate/backups`.
- [ ] Break something (e.g. `mv ~/.zshrc ~/.zshrc.gone`), then
      `tu restore ~/.termux-ultimate/backups/tu-backup-*.tar.gz` — your
      `.zshrc` comes back.
- [ ] The restore step saves a `pre-restore-*.tar.gz` safety backup.

## 7. Uninstall

- [ ] `tu uninstall shell` restores your original `.zshrc`/`.tmux.conf` (if they
      existed) and removes Oh My Zsh. `zsh` no longer exists as login shell.
- [ ] Full `tu uninstall` removes `tu` from PATH, restores configs, and deletes
      `~/.termux-ultimate`.

## 8. Line endings (regression)

- [ ] `file ~/.termux-ultimate/tu` reports "ASCII text" — NOT "with CRLF line terminators".
- [ ] `curl -fsSL <install.sh URL> | head -c 100 | od -c | head` shows `\n` only — no `\r`.

---

Report any failing step with its output — that's how the project gets better.