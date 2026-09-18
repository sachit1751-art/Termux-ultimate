#!/data/data/com.termux/files/usr/bin/bash

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    exit 1
}

assert_contains() {
    local file="$1"
    local expected="$2"
    grep -Fq "$expected" "$file" || fail "$file does not contain: $expected"
}

MODULES_FILE="$ROOT/modules/modules.conf"
[ -f "$MODULES_FILE" ] || fail "shared module metadata is missing"

# shellcheck source=/dev/null
. "$MODULES_FILE"
[ "${MODULES:-}" = "shell python node ai media lazygit lang dev" ] || \
    fail "module order changed unexpectedly"
[ "$(module_count)" -eq 8 ] || fail "module_count should return the number of modules"
[ "$(describe_module lazygit)" = "Lazygit - terminal UI for git" ] || \
    fail "module description is incorrect"

assert_contains "$ROOT/install.sh" 'INSTALL_FAILURES=$((INSTALL_FAILURES + 1))'
assert_contains "$ROOT/install.sh" 'exit 1'
assert_contains "$ROOT/tu" 'MODULE_COUNT="$(module_count)"'
assert_contains "$ROOT/modules/backup.sh" 'tar -tzf "$file" >/dev/null'
assert_contains "$ROOT/modules/backup.sh" '*/../*'
assert_contains "$ROOT/tu" "IFS=',' read -ra requested"
assert_contains "$ROOT/tu" 'self-test)'
assert_contains "$ROOT/tu" 'exit 2'
assert_contains "$ROOT/modules/doctor.sh" 'JSON_MODE'
assert_contains "$ROOT/tu" '--dry-run'
assert_contains "$ROOT/modules/uninstall.sh" 'DRY_RUN'
assert_contains "$ROOT/modules/backup.sh" '--list)'
assert_contains "$ROOT/modules/update.sh" '--check'
assert_contains "$ROOT/tu" 'status)'
assert_contains "$ROOT/tu" '--full'
assert_contains "$ROOT/modules/shell/config.sh" "doctor) _values 'format' --json"
assert_contains "$ROOT/modules/shell/config.sh" 'all shell python node ai media lazygit lang dev'
assert_contains "$ROOT/modules/modules.conf" 'dev'
assert_contains "$ROOT/modules/doctor.sh" 'clang'
assert_contains "$ROOT/modules/repair.sh" 'modules/dev.sh'
assert_contains "$ROOT/modules/uninstall.sh" 'dev)'
assert_contains "$ROOT/tu" '--quiet'
assert_contains "$ROOT/tu" '--tail'
assert_contains "$ROOT/modules/backup.sh" '--json'
assert_contains "$ROOT/modules/update.sh" 'remote.origin.url'
assert_contains "$ROOT/install.sh" 'retry-failed'
assert_contains "$ROOT/tu" 'project init'
assert_contains "$ROOT/tu" 'status --json'
assert_contains "$ROOT/tu" 'version --json'

printf 'PASS: production hardening regression checks\n'