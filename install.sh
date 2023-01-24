#!/usr/bin/env bash

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

TARGET="${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
mkdir -p "$TARGET"
cp init.lua "$TARGET"/init.lua

nvim --headless +PackerInstall +qa
