# dotfiles

- **bin/**: Anything in `bin/` will get added to the `$PATH` and be made available everywhere.
- **Brewfile**: The command-line tools and apps that `brew bundle` installs.
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

Import the Oceanic-Next iTerm color profile and select it in iTerm color preferences:

```
open ~/.dotfiles/iterm/Oceanic-Next.itermcolors
```

The bootstrap script prompts you to configure macOS system defaults on Mac (keyboard repeat rate, trackpad tap-to-click, etc.). You can apply or re-apply these settings anytime by running:

```bash
set-defaults
```

See `~/.dotfiles/macos/README.md` for details on what settings are applied and how to customize them.

Run `check-security` now and then to see whether FileVault, the firewall, Gatekeeper, automatic updates and the other security settings are still on. It only reports.

Run `dot` now and then to keep things up to date: it updates Homebrew, installs
everything in the Brewfile and runs each topic's `install` script. It lives in
`bin/`.

## thanks

I forked [Zach Holman](http://github.com/holman)'s excellent [dotfiles](http://github.com/holman/dotfiles) and tweaked it.
