#!/bin/bash
# Save / apply Rex.app preferences (macOS defaults domain com.superlogical.rex).
#
#   ./rex/scripts/settings.sh save    # snapshot this machine's settings -> rex/scripts/settings.plist
#   ./rex/scripts/settings.sh apply   # merge rex/scripts/settings.plist into this machine's settings
#   ./rex/scripts/settings.sh diff    # show which saved keys differ from this machine

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$SCRIPT_DIR/../../scripts/utils.sh"

DOMAIN="com.superlogical.rex"
APP_NAME="Rex"
SETTINGS_FILE="$SCRIPT_DIR/settings.plist"

# Portable-key filter shared by save/apply/diff. Keys are kept when they match
# an INCLUDE prefix/key and are not listed in EXCLUDE (machine-specific or runtime state).
filter_py='
import plistlib, sys

INCLUDE_PREFIXES = ("Workspace.",)
INCLUDE_KEYS = {
    "rex.agents.names-sessions",
    "rex.developer-mode-enabled",
    "rex.server.automatic-restart-enabled",
    "rex.server.block-plugin-reload-enabled",
}
EXCLUDE_KEYS = {
    "Workspace.lastFocusedSession",
    "Workspace.programActivitySeen",
}

def portable(prefs):
    return {
        k: v for k, v in prefs.items()
        if (k.startswith(INCLUDE_PREFIXES) or k in INCLUDE_KEYS) and k not in EXCLUDE_KEYS
    }
'

export_domain() {
  defaults export "$DOMAIN" - 2>/dev/null || error "No preferences found for $DOMAIN (has Rex been launched?)"
}

rex_running() {
  pgrep -xq "$APP_NAME"
}

cmd_save() {
  export_domain | python3 -c "$filter_py"'
prefs = portable(plistlib.loads(sys.stdin.buffer.read()))
with open(sys.argv[1], "wb") as f:
    plistlib.dump(prefs, f, sort_keys=True)
print(len(prefs))
' "$SETTINGS_FILE" | {
    read -r count
    success "Saved $count settings to ${SETTINGS_FILE#"$HOME"/}"
  }
}

cmd_diff() {
  [[ -f "$SETTINGS_FILE" ]] || { error "Missing $SETTINGS_FILE"; exit 1; }
  local current
  current="$(mktemp)"
  trap 'rm -f "$current"' RETURN
  defaults export "$DOMAIN" "$current" 2>/dev/null || printf '<plist version="1.0"><dict/></plist>' >"$current"
  python3 -c "$filter_py"'
saved = plistlib.load(open(sys.argv[1], "rb"))
current = portable(plistlib.load(open(sys.argv[2], "rb")))
diffs = [k for k in sorted(saved) if current.get(k) != saved[k]]
for k in diffs:
    cur, new = repr(current.get(k, "<unset>")), repr(saved[k])
    print(f"  {k}: {cur[:60]} -> {new[:60]}")
extra = sorted(set(current) - set(saved))
for k in extra:
    print(f"  {k}: only on this machine (not saved)")
if not diffs and not extra:
    print("  no differences")
' "$SETTINGS_FILE" "$current"
}

cmd_apply() {
  [[ -f "$SETTINGS_FILE" ]] || { error "Missing $SETTINGS_FILE"; exit 1; }

  local relaunch=false
  if rex_running; then
    if [[ "${1:-}" != "--yes" ]]; then
      warning "$APP_NAME is running; it may overwrite settings on quit."
      warning "Quit $APP_NAME and re-run from another terminal, or pass --yes to quit and relaunch it."
      exit 1
    fi
    info "Quitting $APP_NAME..."
    osascript -e "tell application \"$APP_NAME\" to quit"
    while rex_running; do sleep 0.5; done
    relaunch=true
  fi

  local merged
  merged="$(mktemp)"
  trap 'rm -f "$merged"' RETURN
  defaults export "$DOMAIN" "$merged" 2>/dev/null || printf '<plist version="1.0"><dict/></plist>' >"$merged"

  python3 -c '
import plistlib, sys
saved = plistlib.load(open(sys.argv[1], "rb"))
merged = plistlib.load(open(sys.argv[2], "rb"))
merged.update(saved)
with open(sys.argv[2], "wb") as f:
    plistlib.dump(merged, f)
print(len(saved))
' "$SETTINGS_FILE" "$merged" | {
    read -r count
    info "Applying $count settings"
  }

  defaults import "$DOMAIN" "$merged"
  success "Rex settings applied"

  if $relaunch; then
    info "Relaunching $APP_NAME..."
    open -a "$APP_NAME"
  fi
}

usage() {
  echo "Usage: $(basename "$0") {save|apply [--yes]|diff}"
}

case "${1:-}" in
  save) cmd_save ;;
  apply) shift; cmd_apply "$@" ;;
  diff) cmd_diff ;;
  *) usage; exit 1 ;;
esac
