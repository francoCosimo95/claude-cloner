# Changelog

## [Unreleased]

## [1.2.0] - 2026-11-06

### Added

- `cloner add` pins the new launcher in the Dock, so nobody pins the running copy by mistake. `--no-dock` skips it, `cloner dock <number>` pins an existing one, and `remove` unpins it.

## [1.1.0] - 2026-11-06

### Changed

- Launcher apps are now created in /Applications, next to Claude, when that folder is writable, and in ~/Applications otherwise. `open` and `update` move launchers made earlier, and `remove` cleans up both places.

## [1.0.1] - 2026-11-06

### Fixed

- Pinning the running copy in the Dock started it on your regular Claude data and signed you in as your main account. `add` and the README now say to pin the launcher instead, and why.

## [1.0.0] - 2026-11-06

First stable release. The commands and options described in the README will not change in a breaking way within 1.x.

### Changed

- The README images share one style, with dark and light versions.
- The README is shorter and plainer: fewer sections and warnings, no diagram.
- The badge colors image shows the Claude icon with each numbered badge.
- The demo video lives in `docs/claude-cloner-demo.mp4`, attached to the project and not to a release.

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
