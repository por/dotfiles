# dotfiles

- **bin/**: Anything in `bin/` will get added to the `$PATH` and be made available everywhere.
- **Brewfile**: This is a list of applications for [Homebrew Cask](http://caskroom.io) to install: things like Chrome and 1Password and stuff.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into the environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into `$HOME`. These get symlinked in when you run `script/bootstrap`.

## install

Run this:

```sh
git clone https://github.com/por/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to the home directory. The initial run will take a while to finish.

Next thing we need to do is set `zsh` as the default shell:

```
chsh -s /bin/zsh
```

Import the Oceanic-Next iTerm color profile and select it in iTerm color preferences:

```
open ~/.dotfiles/iterm/Oceanic-Next.itermcolors
```

Go to System Preferences > Keyboard > Shortcuts > Mission Control and uncheck the “Mission Control” and “Application Window” shortcuts. This is because we will want to use this shortcut to do multiline selects in Atom.

`dot` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Occasionally run `dot` from time to time to keep the environment fresh and up-to-date. This script lives in `bin/`.

## thanks

I forked [Zach Holman](http://github.com/holman)'s excellent [dotfiles](http://github.com/holman/dotfiles) and tweaked it.
