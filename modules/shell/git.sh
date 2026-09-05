#!/data/data/com.termux/files/usr/bin/bash

# Termux Ultimate - git configuration
# Sets global aliases and sensible defaults. Idempotent; safe to re-run.

set -e

echo "Configuring git..."

git config --global init.defaultBranch main
git config --global push.default simple
git config --global pull.rebase false
git config --global color.ui auto
git config --global core.editor nano

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg 'log --oneline --graph --decorate -20'
git config --global alias.amend 'commit --amend'

echo "✓ git configured (try: git lg, git st)"