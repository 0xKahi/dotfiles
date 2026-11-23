# Rex App Settings

Rex has two kinds of config:

- **Server config** (`rex/init.lua`, `keybinds/`, `actions/`, …) is already symlinked to `~/.config/rex`, so it comes along with the dotfiles.
- **App settings** (theme, font, padding, cursor, notifications, …) are stored in macOS defaults (`com.superlogical.rex`). The script below takes care of these.

## Files

- **settings.plist**: a snapshot of the portable app settings, including custom themes
- **settings.sh**: saves, applies or diffs those settings

## Syncing Settings

### Requirements
- `python3` installed


### Running the Script

```sh
chmod +x ./rex/scripts/settings.sh
```

#### Save Current Settings

```sh
./rex/scripts/settings.sh save
```

#### Restore on Another Machine

Quit Rex first. Otherwise the app may overwrite the settings when it quits:

```sh
./rex/scripts/settings.sh apply
```

Or let the script quit Rex and relaunch it for you. Run this from a terminal outside Rex:

```sh
./rex/scripts/settings.sh apply --yes
```

#### Check for Drift

```sh
./rex/scripts/settings.sh diff
```

## What's Synced

- All `Workspace.*` keys (appearance, themes, `customThemes`, fonts, padding, panes, tabs, cursor, activity/notification prefs)
- `rex.agents.names-sessions`, `rex.developer-mode-enabled`, `rex.server.automatic-restart-enabled`, `rex.server.block-plugin-reload-enabled`

Skipped because they're machine-specific or runtime state: window frames, `Workspace.lastFocusedSession`,
`Workspace.programActivitySeen`, `rex.client.*` (label, Remote Control), `rex.server.tailnet-*`,
the cached server route, Sparkle updater state and onboarding state.

To sync more keys, edit `INCLUDE_KEYS` / `EXCLUDE_KEYS` in `settings.sh`.

## Warning

These are Rex's internal preference keys, not a public API. A Rex update may rename or drop keys without notice.
When that happens, `apply` still writes the old keys, but Rex ignores them and those settings don't carry over.

- Save and apply with the same Rex version where possible.
- After updating Rex, run `save` again and check `git diff rex/scripts/settings.plist` for renamed or removed keys.
- After applying, run `diff` once Rex has relaunched to confirm the values stuck.
- Remote Control isn't synced. On a new machine, turn it on in the app if you want to use `rex -C <client> do client.setting.*`.

