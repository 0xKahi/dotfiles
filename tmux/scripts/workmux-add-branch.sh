#!/usr/bin/env bash

read -e -r -p 'Branch: ' branch
[ -z "$branch" ] && exit 0

workmux add "$branch" || {
  echo
  echo 'workmux add failed. Press any key to close.'
  read -r -n 1 -s
}
