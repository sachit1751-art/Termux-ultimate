# Production Hardening Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make Termux Ultimate safer to install, easier to validate, and less likely to report a successful setup when a component failed.

**Architecture:** Keep the existing Bash CLI and module layout. Add one shared metadata file for module names and descriptions, source it from the installer and CLI, and use small shell tests for pure selection and failure behavior. Preserve all existing public commands.

**Tech Stack:** Termux Bash, POSIX shell utilities, ShellCheck, GitHub Actions.

**Spec:** Approved production-hardening slice from the 2026-09-18 conversation.

## Global Constraints

- Scripts must retain LF line endings and the Termux Bash shebang.
- Real installers must not run in the development environment; validation uses syntax checks and sandboxed helper tests.
- Existing module names and CLI commands remain backward compatible.
- Selected-module failures must produce a non-zero installer exit status.
- CI must run syntax checks and ShellCheck for every tracked script.

---

### Task 1: Centralize Module Metadata

**Files:**
- Create: `modules/modules.conf`
- Modify: `tu`
- Modify: `install.sh`

**Interfaces:**
- `modules/modules.conf` defines `MODULES` as an ordered space-separated list and `describe_module()` as the shared description function.
- `tu` and `install.sh` source the file using their repository root.

- [ ] Add the ordered module list and descriptions to `modules/modules.conf`.
- [ ] Source the metadata from `tu` and remove its duplicated module list and description case.
- [ ] Source the metadata from `install.sh` and remove its duplicated module list and description case.
- [ ] Replace hard-coded selection bounds with the computed module count.
- [ ] Run `bash -n` on all changed scripts.

### Task 2: Make Installer Outcomes Trustworthy

**Files:**
- Modify: `install.sh`
- Modify: `tu`

**Interfaces:**
- `install.sh` tracks whether any requested module failed and exits non-zero after printing a failure summary.
- `tu` rejects invalid module names without invoking a nonexistent script.

- [ ] Add a failure counter around selected module installation.
- [ ] Preserve installation of later selected modules after one failure.
- [ ] Exit with status 1 when at least one selected module fails.
- [ ] Guard Termux-only CLI operations with a clear environment error where appropriate.
- [ ] Run focused shell tests for success and failure paths.

### Task 3: Add Regression Tests

**Files:**
- Create: `tests/test.sh`
- Modify: `.github/workflows/ci.yml`

**Interfaces:**
- `tests/test.sh` is a dependency-free Bash test runner that exercises metadata loading, selection bounds, and installer failure propagation through temporary fixtures.

- [ ] Write failing assertions for metadata loading and computed module count.
- [ ] Write failing assertions for a simulated selected-module failure returning non-zero.
- [ ] Implement the smallest production changes needed for the assertions.
- [ ] Run `bash tests/test.sh` and verify all assertions pass.
- [ ] Add the test runner to CI before the syntax and ShellCheck gate.

### Task 4: Release and Documentation Consistency

**Files:**
- Modify: `README.md`
- Modify: `CHANGELOG.md`
- Modify: `TESTING.md`

- [ ] Document installer failure exit behavior and the test command.
- [ ] Record the hardening changes in the unreleased changelog section.
- [ ] Add the regression test and production pre-release checks to the testing checklist.
- [ ] Run the full local validation command matching CI.