#!/usr/bin/env bash

echo Installing yegappan/lsp
mkdir -p $HOME/.vim/pack/downloads/opt
cd $HOME/.vim/pack/downloads/opt
git clone https://github.com/yegappan/lsp
vim -u NONE -c "helptags $HOME/.vim/pack/downloads/opt/lsp/doc" -c q

