#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TARGET="$HOME/.vimrc"
SOURCE="$SCRIPT_DIR/.vimrc"

if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "~/.vimrc already exists and is not a symlink. Aborting."
    exit 1
fi

ln -sf "$SOURCE" "$TARGET"

echo "Linked $SOURCE -> $TARGET"

