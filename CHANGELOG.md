# Changelog

## [Unreleased]

## [0.2.1] - 2026-11-06

### Fixed

- Profiles now start Claude with its own `CLAUDE_CONFIG_DIR`, so Claude Code inside the app no longer shares the login of your regular Claude.

## [0.2.0] - 2026-11-06

### Changed

- Profiles are numbered from 2. `add` takes the next free number, or the one you give; `open`, `update`, `remove` and `cli` take the number.
- `remove` deletes the login and data too; use `--keep-data` to keep them.
- The badge always shows the profile number, so the color follows the number.

### Removed

- Profile names and the `--badge` option.

## [0.1.0] - 2026-11-06

### Added

- `add`, `open`, `list`, `update`, `remove` and `cli` commands.
- Launcher apps in `~/Applications` with a badge icon, one color per number.
- Automatic profile update when the installed Claude is newer.
- APFS clone copies, with a plain copy as fallback.
