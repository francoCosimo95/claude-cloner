# Security

## What this tool touches

- It reads `/Applications/Claude.app` and makes copies under `~/.claude-profiles`.
- It creates launcher apps in `~/Applications`.
- It never modifies the original Claude app and never sends anything over the network.

Each profile folder holds that account's login and data. Treat `~/.claude-profiles` like you treat your Claude login: do not share it, sync it to public places or commit it.

## Reporting a vulnerability

Please report it privately through the repository's **Security** tab ("Report a vulnerability"), not in a public issue. You will get a first answer within a few days.
