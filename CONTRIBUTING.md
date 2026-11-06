# Contributing

Thanks for stopping by. Fixes, ideas, docs and new features are all welcome, and you do not need to ask first for small things.

## Pillars

Every change should keep the project:

- **Easy:** one command to add a profile, nothing to configure.
- **Tiny:** one bash script, no dependencies, nothing to compile.
- **Native:** only tools that ship with macOS.
- **Safe:** never touch the original Claude app or its data, never send anything off the machine.
- **Fast:** adding or opening a profile should feel instant.

If a change trades one of these for another, say so in the pull request.

## Rules

- `bash` 3.2 compatible (the one macOS ships) and macOS built-in tools only.
- No comments in code: write it so it reads on its own.
- English, short sentences, no em dash characters (CI checks).
- No real logins, tokens or personal paths in code, tests or docs.

## Layout

| Path | What |
| --- | --- |
| `cloner` | the whole tool |
| `tests/smoke.sh` | end to end test with a fake Claude app, no real Claude needed |
| `docs/` | README graphics |
| `.github/` | issue and pull request templates, CI |

## Develop

```bash
./tests/smoke.sh
```

The smoke test builds a fake `Claude.app` in a temp folder and runs `add`, `list`, `update`, `remove` against it, so your real Claude and your real profiles stay untouched. All paths can be redirected with `CLAUDE_CLONER_HOME`, `CLAUDE_CLONER_APPS` and `CLAUDE_CLONER_SOURCE`.

## Pull requests

One topic per pull request, a test when behavior changes, a line under `## [Unreleased]` in `CHANGELOG.md`, and conventional commit titles (`feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `chore:`).

## Ideas that would be great

See the roadmap in the README. If you want to take one, open an issue so nobody does the same work twice.
