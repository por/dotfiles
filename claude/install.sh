#!/bin/bash
# Symlink Claude Code skills directory

CLAUDE_DIR="$HOME/.claude"
DOTFILES_CLAUDE_DIR="$HOME/.dotfiles/claude"

# Create ~/.claude if it doesn't exist
mkdir -p "$CLAUDE_DIR"

# Symlink skills directory
if [ -L "$CLAUDE_DIR/skills" ]; then
    rm "$CLAUDE_DIR/skills"
elif [ -d "$CLAUDE_DIR/skills" ]; then
    echo "Warning: ~/.claude/skills exists and is not a symlink. Backing up..."
    mv "$CLAUDE_DIR/skills" "$CLAUDE_DIR/skills.backup"
fi

ln -s "$DOTFILES_CLAUDE_DIR/skills" "$CLAUDE_DIR/skills"
echo "Linked Claude skills directory"
