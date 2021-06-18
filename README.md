# A New Programming Environment

This is a new configuration for Neovim designed to simplify my current
Emacs + Vim + VSCode mess. Unfortunately Neovim doesn't seem to have a built-in
package manager like Emacs does – I'll need a little more than just my config
file.

## Installing A Package Manager

Since I'm going to try to stick to Neovim 0.5 "best-practices", I'm going to
use a Lua-based package manager called `paq-nvim`. This **should** be the only
non-config step required?

```sh
git clone --depth=1 https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim
```

## Configuration

I'm planning on stealing a bit from here: https://oroques.dev/notes/neovim-init/

The actual goodies are in the `init.lua` file!

## Installing Everything

If you're feeling lazy, you can just run `install.sh` which *should* just work.
