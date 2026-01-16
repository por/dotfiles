#!/usr/bin/env bash
#
# Sets macOS system defaults for keyboard and trackpad
#
# Called automatically during script/bootstrap on macOS
# Can be re-run manually via: set-defaults (from anywhere)
# Or directly: ~/.dotfiles/macos/set-defaults.sh

set -e

# Only run on macOS (matches pattern from script/bootstrap:36,144)
if [ "$(uname -s)" != "Darwin" ]; then
  echo "This script only runs on macOS"
  exit 0
fi

echo ""
echo "Setting macOS system defaults..."
echo ""

# Keyboard: Set key repeat rate to fastest
# KeyRepeat: 2 = fastest, 15 = slowest
echo "› Setting keyboard repeat rate to fastest (2)"
defaults write NSGlobalDomain KeyRepeat -int 2

# Keyboard: Set initial key repeat delay to shortest (fastest to start repeating)
# InitialKeyRepeat: 15 = shortest delay, 120 = longest delay
echo "› Setting keyboard delay until repeat to shortest (15)"
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Trackpad: Enable tap to click for this user and login screen
echo "› Enabling tap to click on trackpad"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: Enable tap to click for built-in trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Zoom: Enable scroll gesture with modifier keys to zoom
echo "› Enabling zoom with scroll gesture and modifier keys"
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true

echo ""
echo "✓ macOS defaults set successfully"
echo ""
echo "IMPORTANT: Changes will not appear immediately in System Settings."
echo "           To apply these settings, you need to:"
echo "           1. Log out and log back in (recommended), OR"
echo "           2. Restart your Mac"
echo ""
echo "After restarting, verify settings in:"
echo "  • System Settings > Keyboard > Key repeat rate (should be fastest)"
echo "  • System Settings > Keyboard > Delay until repeat (should be shortest)"
echo "  • System Settings > Trackpad > Tap to click (should be ON)"
echo "  • System Settings > Accessibility > Zoom > Use scroll gesture with modifier keys to zoom (should be ON)"
echo ""
