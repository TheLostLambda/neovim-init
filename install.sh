#!/usr/bin/env bash

git clone --depth=1 https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim

cp init.lua "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim/init.lua

nvim --headless +PaqInstall +qa
