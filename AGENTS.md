# AGENTS.md

Guidance for AI coding agents working in this repository.

## What this is

**Termux Ultimate** — a set of bash scripts that turn Termux (the Android
terminal emulator) into a developer environment. A `tu` CLI dispatches to
idempotent install modules. It runs on real Linux bash inside Termux, not on
desktop Linux, Windows, or macOS.

## Critical rules

- **LF line endings, always.** The scripts run under Linux bash where CRLF
  breaks everything (the shebang `#!/.../bash\r` is an invalid interpreter).
  `.gitattributes` enforces LF, but never introduce a CRLF file anyway. If a
  file shows `\r` warnings, run `sed -i 's/\r$//' <file>` before staging.
- **Never run the scripts for real here.** They mutate `$HOME` and `$PREFIX`.
  For logic tests, sandbox with `HOME=tmp/<dir> PREFIX=tmp/<dir> bash <script>`
  using a temp dir inside `tmp/` (gitignored).
- **Shell style:** shebang `#!/data/data/com.termux/files/usr/bin/bash`,
  `set -e` (except `tu`, which must never abort the menu), guard
  `[ -z "$PREFIX" ]` where Termux is required, keep installs idempotent
  (skip when `command -v` succeeds), friendly `✓`/`!` output, and installer
  modules print a summary (versions where available) plus `elapsed: Ns`.
- **Verify before committing:** `bash -n` on every script, then
  `shellcheck -s bash -S warning` (a local copy lives at `tmp/shellcheck.exe`;
  CI runs the same checks on Ubuntu).
- **Commit style:** conventional-commit subject (`feat:`, `fix:`, `docs:`,
  `chore:`), a body explaining the *why*, and this footer:
  `Generated with Codebuff 🤖` / `Co-Authored-By: Codebuff <noreply@codebuff.com>`.
  Never alter git config. No force-push or history rewrite without an explicit
  user request.
- **Do not recreate automation that generates fake commits.** See the history
  note below.

## Repo layout

- `tu` — CLI dispatcher: interactive menu, module picker with descriptions,
  and commands (`install`, `doctor`, `repair`, `update`, `uninstall`,
  `backup`, `restore`, `logs`, `version`). Resolves its real path when
  symlinked into `$PREFIX/bin` (see the `while [ -L ... ]` loop at the top —
  do not regress that).
- `install.sh` — one-command installer (`curl | bash`): bootstrap packages,
  clone into `~/.termux-ultimate`, symlink `tu` to `$PREFIX/bin`, request
  storage access, interactive module selection (numbers / `all` / args).
- `uninstall.sh` — full uninstaller; requires interactive confirmation and
  refuses to run without a terminal.
- `VERSION` — single source of truth for the version (read by `tu`;
  `install.sh` fetches it from GitHub raw).
- `modules/` — one script per install module: `shell.sh` (orchestrates the
  steps in `modules/shell/`), `python.sh`, `node.sh`, `ai.sh`, `media.sh`,
  `lazygit.sh`, `lang.sh` — plus tooling: `doctor.sh` (health + update
  check), `repair.sh`, `update.sh`, `backup.sh`, `uninstall.sh`
  (per-module).
- `modules/shell/` — steps: `install.sh` (package list), `plugins.sh`,
  `config.sh` (`.zshrc`: aliases, greeting, theme switcher, `tu` completion),
  `fastfetch.sh`, `tmux.sh`, `git.sh`, `themes/*.properties` (Termux color
  schemes: catppuccin, tokyonight, dracula).
- `.github/workflows/ci.yml` — `bash -n` + shellcheck on every push and PR.
- `TESTING.md` — end-to-end checklist to run on a real phone.
- `CHANGELOG.md` — release notes; keep in sync with `VERSION`.

## How to add a module

1. Create `modules/<name>.sh` following the pattern: banner, `START=$(date +%s)`,
   PREFIX guard, idempotent install steps, summary with versions + elapsed time.
2. Add it to the `MODULES` list in `tu` and `install.sh`, plus a
   `describe_module` case in both, and update the numeric range checks
   (`-le N` in `pick_module` and the installer prompt) to match the new
   module count.
3. Add `check "<name>" "<binary>"` to `modules/doctor.sh`, a repair branch in
   `modules/repair.sh`, and an uninstall branch in `modules/uninstall.sh`.
4. Update `show_help` in `tu`, the README feature list, `CHANGELOG.md`, and
   `TESTING.md` if user-facing.
5. Verify: `bash -n`, shellcheck, and a sandbox run with `HOME`/`PREFIX`
   overrides before touching anything real.

## History note

The early git history contains ~690 automated fake commits (contribution-graph
spam, messages like `perf: reduce redundant allocations [skip ci]`) plus one
stray `[skip ci]` commit from the workflow's last run before it was disabled.
The user chose to keep that history. New commits must be real and honest; never
add `[skip ci]` or fake messages.

## Versioning

`VERSION` is the single source of truth. On release: bump `VERSION`, move/add
the `CHANGELOG.md` section, update the README badge and status line, tag
`vX.Y.Z`, and push the tag. Never let a stale version string linger in
`install.sh`'s fallback either.