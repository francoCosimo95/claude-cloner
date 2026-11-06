#!/bin/bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLI="$HERE/cloner"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/cloner-test.XXXXXX")"
trap 'rm -rf "$WORK"' EXIT

export CLAUDE_CLONER_HOME="$WORK/home"
export CLAUDE_CLONER_APPS="$WORK/apps"
export CLAUDE_CLONER_SOURCE="$WORK/source/Claude.app"
mkdir -p "$CLAUDE_CLONER_APPS"

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
  local app="$CLAUDE_CLONER_SOURCE"
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
  "$CLI" list | awk -v n="$1" '$1 == n { print $2 }'
}

listed_numbers() {
  "$CLI" list | awk 'NR > 1 { print $1 }' | paste -sd, -
}

make_fake_app 1.0.0

"$CLI" version | grep -q "^cloner " || fail "version output"
pass "version"

"$CLI" add >/dev/null
[ -d "$CLAUDE_CLONER_APPS/Claude 2.app" ] || fail "first add should create profile 2"
[ -f "$CLAUDE_CLONER_HOME/profiles/2/icon.icns" ] || fail "icon not built"
[ "$(listed_version 2)" = "1.0.0" ] || fail "version not listed"
pass "first add creates profile 2 with launcher and icon"

"$CLI" add >/dev/null
"$CLI" add >/dev/null
[ "$(listed_numbers)" = "2,3,4" ] || fail "numbers should be 2,3,4 but are $(listed_numbers)"
pass "add takes the next free number"

"$CLI" remove 3 >/dev/null
[ "$(listed_numbers)" = "2,4" ] || fail "remove 3 should leave 2,4"
[ ! -d "$CLAUDE_CLONER_HOME/profiles/3" ] || fail "remove should delete the data too"
[ ! -d "$CLAUDE_CLONER_APPS/Claude 3.app" ] || fail "launcher not removed"
pass "remove deletes that number"

"$CLI" add >/dev/null
[ "$(listed_numbers)" = "2,3,4" ] || fail "add should fill the gap with 3"
pass "add fills the gap"

"$CLI" add 7 >/dev/null
[ "$(listed_numbers)" = "2,3,4,7" ] || fail "explicit number"
pass "add accepts an explicit number"

"$CLI" add 7 >/dev/null 2>&1 && fail "duplicate add should fail"
pass "duplicate number is rejected"

for bad in 0 1 02 abc -3 1000; do
  "$CLI" add "$bad" >/dev/null 2>&1 && fail "add $bad should fail"
done
pass "invalid numbers are rejected"

make_fake_app 1.1.0
"$CLI" update >/dev/null
[ "$(listed_version 2)" = "1.1.0" ] || fail "profile 2 not updated"
[ "$(listed_version 7)" = "1.1.0" ] || fail "profile 7 not updated"
pass "update follows a newer Claude"

make_fake_app 0.9.0
"$CLI" update >/dev/null
[ "$(listed_version 2)" = "1.1.0" ] || fail "profile was downgraded"
pass "update never downgrades"

touch "$CLAUDE_CLONER_HOME/profiles/4/data/login-marker"
"$CLI" remove 4 --keep-data >/dev/null
[ -f "$CLAUDE_CLONER_HOME/profiles/4/data/login-marker" ] || fail "--keep-data lost the data"
[ "$(listed_numbers)" = "2,3,7" ] || fail "profile 4 should be gone from the list"
"$CLI" add >/dev/null
[ "$(listed_numbers)" = "2,3,4,7" ] || fail "add should reuse 4"
[ -f "$CLAUDE_CLONER_HOME/profiles/4/data/login-marker" ] || fail "kept data should come back"
pass "--keep-data keeps the login for when the number comes back"

echo "$PASSED checks passed"
