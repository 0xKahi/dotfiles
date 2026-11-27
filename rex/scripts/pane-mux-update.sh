#!/bin/bash
# Install/update pane-mux from crates.io only when a newer version is available.

crate="pane-mux"

installed=$(cargo install --list | awk -v c="$crate" '$1 == c {gsub(/^v|:$/, "", $2); print $2}')
latest=$(cargo search "$crate" --limit 1 | awk -F'"' -v c="$crate" '$0 ~ "^" c " =" {print $2}')

if [ -z "$latest" ]; then
  echo "Could not determine the latest $crate version from crates.io" >&2
  exit 1
fi

if [ "$installed" == "$latest" ]; then
  echo "$crate is up to date ($installed)"
  exit 0
fi

echo "Updating $crate: ${installed:-none} -> $latest"./rex/init.lua:L27-L30
cargo install "$crate" --locked
