#!/bin/bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLI="$HERE/claude-profiles"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/claude-profiles-test.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

export CLAUDE_PROFILES_HOME="$WORK/home"
export CLAUDE_PROFILES_APPS="$WORK/apps"
export CLAUDE_PROFILES_SOURCE="$WORK/source/Claude.app"
mkdir -p "$CLAUDE_PROFILES_APPS"

ICON="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericApplicationIcon.icns"
PASSED=0

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

pass() {
  PASSED=$((PASSED + 1))
  echo "ok - $1"
}

make_fake_app() {
  local app="$CLAUDE_PROFILES_SOURCE"
  rm -rf "$app"
  mkdir -p "$app/Contents/MacOS" "$app/Contents/Resources"
  printf '#!/bin/bash\nexit 0\n' >"$app/Contents/MacOS/Claude"
  chmod +x "$app/Contents/MacOS/Claude"
  cp "$ICON" "$app/Contents/Resources/electron.icns"
  cat >"$app/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key><string>Claude</string>
  <key>CFBundleIdentifier</key><string>test.fake.claude</string>
  <key>CFBundleIconFile</key><string>electron</string>
  <key>CFBundleVersion</key><string>$1</string>
  <key>CFBundlePackageType</key><string>APPL</string>
</dict>
</plist>
PLIST
}

listed_version() {
  "$CLI" list | awk -v n="$1" '$1 == n { print $3 }'
}

make_fake_app 1.0.0

"$CLI" version | grep -q "^claude-profiles " || fail "version output"
pass "version"

"$CLI" add work >/dev/null
[ -d "$CLAUDE_PROFILES_APPS/Claude work.app" ] || fail "launcher not created"
[ -f "$CLAUDE_PROFILES_HOME/profiles/work/icon.icns" ] || fail "icon not built"
[ "$(listed_version work)" = "1.0.0" ] || fail "version not listed"
pass "add creates profile, launcher and icon"

"$CLI" add work >/dev/null 2>&1 && fail "duplicate add should fail"
pass "duplicate name is rejected"

"$CLI" add "bad name" >/dev/null 2>&1 && fail "invalid name should fail"
pass "invalid name is rejected"

"$CLI" add home --badge H >/dev/null
[ "$(cat "$CLAUDE_PROFILES_HOME/profiles/home/badge")" = "H" ] || fail "custom badge"
pass "custom badge"

make_fake_app 1.1.0
"$CLI" update >/dev/null
[ "$(listed_version work)" = "1.1.0" ] || fail "profile not updated"
[ "$(listed_version home)" = "1.1.0" ] || fail "second profile not updated"
pass "update follows a newer Claude"

make_fake_app 0.9.0
"$CLI" update >/dev/null
[ "$(listed_version work)" = "1.1.0" ] || fail "profile was downgraded"
pass "update never downgrades"

touch "$CLAUDE_PROFILES_HOME/profiles/work/data/login-marker"
"$CLI" remove work >/dev/null
[ ! -d "$CLAUDE_PROFILES_APPS/Claude work.app" ] || fail "launcher not removed"
[ -f "$CLAUDE_PROFILES_HOME/profiles/work/data/login-marker" ] || fail "data was deleted without --purge"
pass "remove keeps data"

"$CLI" remove work --purge >/dev/null
[ ! -d "$CLAUDE_PROFILES_HOME/profiles/work" ] || fail "purge left files"
pass "remove --purge deletes everything"

echo "$PASSED checks passed"
