# claude-profiles

Run several Claude desktop apps on your Mac at the same time, each one logged in with a different account.

One shell script. No dependencies, no installer, nothing to compile. It only uses tools that ship with macOS.

```
$ claude-profiles add work
$ claude-profiles add personal
$ claude-profiles list
NAME                 BADGE  VERSION      STATE
work                 2      4.4212.0     running
personal             3      4.4212.0     closed
```

Each profile gets:

- its own login, settings and history (a separate data folder)
- its own launcher app, `Claude work.app`, in `~/Applications`, so it shows up in Spotlight and Launchpad
- an icon with a badge, so you can tell the instances apart
- automatic updates: the profile follows your installed Claude

## Requirements

- macOS (Apple Silicon or Intel)
- Claude desktop installed in `/Applications/Claude.app`

That is all. The script uses `bash`, `osascript`, `sips`, `iconutil`, `codesign` and `cp`, which are already on your Mac.

## Install

```bash
git clone https://github.com/francoCosimo95/claude-profiles.git
cd claude-profiles
./claude-profiles add work
```

Optional, to call it from anywhere:

```bash
mkdir -p ~/.local/bin
cp claude-profiles ~/.local/bin/
```

## Usage

```
claude-profiles add <name> [--badge TEXT]   create a profile and its launcher app
claude-profiles open <name>                 open a profile (updates it first if needed)
claude-profiles list                        show profiles, versions and state
claude-profiles update [name] [--force]     refresh profile copies from the installed Claude
claude-profiles remove <name> [--purge]     delete a profile (--purge also deletes its login and data)
claude-profiles cli <name> [args...]        run the Claude Code CLI with the profile's own login
```

After `add`, open the new launcher from Spotlight (`Claude work`) or run `claude-profiles open work`, then sign in with the account you want for that profile. The next time, the login is remembered.

The badge defaults to a number (2, 3, 4...) and each number has its own color: blue, green, purple, pink, teal, red, amber, slate, then the cycle repeats. Use `--badge W` for a letter or up to two characters; its color is picked from the same palette.

### Claude Code in the terminal

`claude-profiles cli work` starts the `claude` command with a separate config folder for that profile (through `CLAUDE_CONFIG_DIR`), so the terminal login is separate too.

## How it works

Claude is an Electron app. Electron keeps all its state in a "user data" folder, which can be changed with `--user-data-dir`. The problem is that macOS opens only one instance of an app unless you ask for a new one with `open -n`.

For each profile, `claude-profiles`:

1. makes a copy of `Claude.app` in `~/.claude-profiles/profiles/<name>/`, using an APFS clone, so the copy takes almost no extra disk space and takes a second to create
2. opens that copy with `open -n --user-data-dir=<profile>/data`, so it has its own login and settings
3. sets the badge icon as a custom icon on the copy, using the same metadata Finder uses when you paste an icon in "Get Info"
4. creates a tiny launcher app that calls the script, and checks the installed Claude version each time it starts: if your Claude was updated, the profile copy is rebuilt before it opens

The copy is never modified inside, so its code signature stays valid. This matters: in testing, copies with an edited app bundle (name, icon file, bundle id) crashed at startup, while an untouched copy ran fine.

Your original Claude is never touched.

## Limitations

- The Dock label stays "Claude". Changing it means editing the app, which breaks it. Use the badge to tell instances apart.
- Updates are applied when you open a profile from its launcher (or run `claude-profiles update`). A profile that is already running is not updated until you close it.
- Each profile is a full copy of the app. On APFS (the default on every recent Mac) the copy is a clone, so it does not use real disk space until the original changes.
- This relies on Claude's current structure (Electron, `--user-data-dir`). A future version of the app could behave differently.

## Uninstall

```bash
claude-profiles remove work --purge
rm -rf ~/.claude-profiles
```

## Disclaimer

This is an unofficial community tool. It is not affiliated with or endorsed by Anthropic. "Claude" is a trademark of Anthropic.

It is meant for people who legitimately use more than one account, for example a work and a personal one. Use it according to the terms of the services you sign in to. It does not copy or redistribute anything: each copy is made on your own Mac from the app you installed.

## License

MIT, see [LICENSE](LICENSE).
