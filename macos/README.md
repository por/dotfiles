# macOS System Defaults

This directory contains macOS-specific system defaults configuration.

## Settings Applied

The `set-defaults.sh` script configures the following macOS system settings:

### Keyboard
- **Key Repeat Rate**: Set to fastest (1) - how fast keys repeat when held down
- **Initial Key Repeat Delay**: Set to shortest (15) - delay before repeating starts

### Trackpad
- **Tap to Click**: Enabled for all trackpads and login screen

## Usage

To apply these settings, run:

```bash
set-defaults
```

Or directly:

```bash
~/.dotfiles/macos/set-defaults.sh
```

## Customization

To customize these settings:

1. Edit `macos/set-defaults.sh`
2. Adjust the values:
   - `KeyRepeat`: 1 (fastest) to 15 (slowest)
   - `InitialKeyRepeat`: 15 (shortest delay, fastest to start) to 120 (longest delay, slowest to start)
3. Run `set-defaults` to apply

## Technical Details

These settings use the macOS `defaults` command to modify system preferences:
- `NSGlobalDomain`: System-wide settings
- `com.apple.driver.AppleBluetoothMultitouch.trackpad`: Bluetooth trackpad
- `com.apple.AppleMultitouchTrackpad`: Built-in trackpad

All settings are idempotent and can be run multiple times safely.

## Platform Detection

The scripts automatically detect macOS and will exit gracefully on other platforms, maintaining cross-platform compatibility of the dotfiles repository.
