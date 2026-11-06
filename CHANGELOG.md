# Changelog

## [Unreleased]

## [0.4.3] - 2026-11-06

### Fixed

- Claude's own updater replaced the profile copy and restarted it without its data folder and badge, which signed you in as your main account. The copy is now locked with the immutable flag so the updater cannot replace it. `open` and `update` lock copies made earlier, and `remove` and rebuilds unlock them first.

### Changed

- The README image shows two Claude chat windows with the app icon and badges, and the demo video link was removed from the README.

## [0.4.2] - 2026-11-06

### Added

- `add` prints the next steps, including the browser sign-in and Dock warnings. `copy` reminds you to reopen the profile and warns about memory and links. `help` lists the same warnings.
- README with the add then copy process, a troubleshooting table, an explanation of the two kinds of memory, and a link to the demo video.

## [0.4.1] - 2026-11-06

### Fixed

- `list` flags a profile that runs without its own data folder, and `open` refuses to start another one. This can happen when Claude updates a copy by itself and restarts it.
- The badge icon is restored by `open` and `update` when it was lost, for example after Claude replaced the app copy.

## [0.4.0] - 2026-11-06

### Added

- `cloner copy <from> <to>` copies skills, agents, commands, hooks, instructions, settings, memory and the desktop MCP config between Claude instances. 1 is the regular Claude. It backs up what it replaces, never copies login or organization files, and supports `--only`, `--link` and `--dry-run`.

## [0.3.0] - 2026-11-06

### Changed

- Renamed to claude-cloner. The command is now `cloner`, data lives in `~/.claude-cloner`, and the environment variables are `CLAUDE_CLONER_HOME`, `CLAUDE_CLONER_APPS` and `CLAUDE_CLONER_SOURCE`.

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
