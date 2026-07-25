#!/usr/bin/env bash

BASHRC="${1:-$HOME/.bashrc}"

if [[ ! -f "$BASHRC" ]]; then
  echo "Bashrc file not found: $BASHRC" >&2
  exit 1
fi

grep -E '^[[:space:]]*alias[[:space:]]+[A-Za-z0-9_-]+=' "$BASHRC" | while IFS= read -r line; do
  name=$(printf '%s\n' "$line" | sed -E "s/^[[:space:]]*alias[[:space:]]+([A-Za-z0-9_-]+)=.*/\1/")
  command=$(printf '%s\n' "$line" | sed -E "s/^[[:space:]]*alias[[:space:]]+[A-Za-z0-9_-]+=['\"](.*)['\"][[:space:]]*$/\1/")
  printf "%s -> %s\n" "$name" "$command"
done
