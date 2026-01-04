# FZF Configuration - Minimal Setup

# Source fzf keybindings and completion
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

if [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/completion.zsh
fi

# Simple, sensible defaults
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --inline-info
"

# Fix Alt-C on macOS/iTerm - use Ctrl-G instead for directory jumping
# (Alt-C doesn't work on Mac without changing iTerm settings)
bindkey '^G' fzf-cd-widget
