#!/usr/bin/env bash

set -euo pipefail

symlink_file() {
    local SRC=$1
    local DST=$2

    if [ -e "$DST" ] && [ ! -L "$DST" ]; then
        echo "$DST already exists and is not a symlink. Aborting."
        exit 1
    fi

    ln -sf "$SRC" "$DST"

    echo "Linked $SRC -> $DST"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

#### Vim

symlink_file "$SCRIPT_DIR/.vimrc" "$HOME/.vimrc" 

#### Git

symlink_file "$SCRIPT_DIR/.gitconfig" "$HOME/.gitconfig" 
symlink_file "$SCRIPT_DIR/.gitignore_global" "$HOME/.gitignore_global"

#### Bash

symlink_file "$SCRIPT_DIR/.inputrc" "$HOME/.inputrc"
symlink_file "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
symlink_file "$SCRIPT_DIR/.bashrc.d" "$HOME/.bashrc.d"
