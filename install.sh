#!/bin/bash
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$(dirname "$DIR")"

stow -t "$HOME" --adopt \
  --ignore='install\.sh' \
  --ignore='README\.md' \
  --ignore='\.gitignore' \
  --ignore='\.stowrc' \
  --ignore='DS_Store' \
  --ignore='\.vim' \
  --ignore='\.obsidian' \
  --ignore='bitbucket\.log' \
  --ignore='etc' \
  "$(basename "$DIR")"
