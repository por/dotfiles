#!/bin/bash
# Manage Claude Code skills via symlinks
# Symlinks ARE the configuration - no install step needed

SKILLS_SRC="$HOME/.dotfiles/agents/skills"
SKILLS_DST="$HOME/.claude/skills"
DEFAULT_FILE="$HOME/.dotfiles/agents/skills.default"

mkdir -p "$SKILLS_DST"

is_enabled() {
    [ -L "$SKILLS_DST/$1" ]
}

enable_skill() {
    local skill="$1"
    if [ ! -d "$SKILLS_SRC/$skill" ]; then
        echo "Error: Skill '$skill' not found in $SKILLS_SRC"
        return 1
    fi
    ln -sfn "$SKILLS_SRC/$skill" "$SKILLS_DST/$skill"
}

disable_skill() {
    rm -f "$SKILLS_DST/$1"
}

interactive_mode() {
    if ! command -v fzf &> /dev/null; then
        echo "fzf not found. Install it or use: skills list|enable|disable"
        exit 1
    fi

    # Build list of skills with current state
    skills_list=""
    for d in "$SKILLS_SRC"/*/; do
        [ -d "$d" ] || continue
        name=$(basename "$d")
        if is_enabled "$name"; then
            skills_list+="[x] $name"$'\n'
        else
            skills_list+="[ ] $name"$'\n'
        fi
    done

    # Remove trailing newline
    skills_list="${skills_list%$'\n'}"

    # Run fzf with multi-select
    selected=$(echo "$skills_list" | fzf --multi --ansi \
        --header="Space: toggle, Enter: apply" \
        --bind="space:toggle" \
        --prompt="Select skills: " \
        --height=~50% \
        --reverse)

    [ -z "$selected" ] && echo "No changes made." && exit 0

    # Toggle selected skills based on their current state
    while IFS= read -r line; do
        [ -z "$line" ] && continue
        skill=$(echo "$line" | sed 's/^\[.\] //')
        if [[ "$line" == "[x]"* ]]; then
            # Currently enabled → disable it
            disable_skill "$skill"
            echo "Disabled: $skill"
        else
            # Currently disabled → enable it
            enable_skill "$skill"
            echo "Enabled: $skill"
        fi
    done <<< "$selected"
}

case "$1" in
    "")
        interactive_mode
        ;;
    list)
        echo "Available skills:"
        for d in "$SKILLS_SRC"/*/; do
            [ -d "$d" ] || continue
            name=$(basename "$d")
            if is_enabled "$name"; then
                echo "  [x] $name"
            else
                echo "  [ ] $name"
            fi
        done
        ;;
    enable)
        if [ -z "$2" ]; then
            echo "Usage: skills enable <skill>"
            exit 1
        fi
        if enable_skill "$2"; then
            echo "Enabled: $2"
        fi
        ;;
    disable)
        if [ -z "$2" ]; then
            echo "Usage: skills disable <skill>"
            exit 1
        fi
        if is_enabled "$2"; then
            disable_skill "$2"
            echo "Disabled: $2"
        else
            echo "Skill '$2' is not enabled"
        fi
        ;;
    init)
        # Bootstrap from skills.default (for fresh installs)
        if [ ! -f "$DEFAULT_FILE" ]; then
            echo "No skills.default found, skipping bootstrap"
            exit 0
        fi

        # Only bootstrap if no skills are currently enabled
        has_skills=false
        for link in "$SKILLS_DST"/*; do
            [ -L "$link" ] && has_skills=true && break
        done

        if $has_skills; then
            echo "Skills already configured, skipping bootstrap"
            exit 0
        fi

        echo "Bootstrapping skills from skills.default..."
        while IFS= read -r skill || [ -n "$skill" ]; do
            # Skip comments and empty lines
            [[ "$skill" =~ ^#.*$ || -z "$skill" ]] && continue
            skill=$(echo "$skill" | xargs)  # trim whitespace
            if enable_skill "$skill"; then
                echo "  Enabled: $skill"
            fi
        done < "$DEFAULT_FILE"
        ;;
    *)
        echo "Usage: skills [list|enable <skill>|disable <skill>|init]"
        echo ""
        echo "Commands:"
        echo "  (no args)         Interactive skill picker (requires fzf)"
        echo "  list              Show all skills and their status"
        echo "  enable <skill>    Enable a skill (creates symlink)"
        echo "  disable <skill>   Disable a skill (removes symlink)"
        echo "  init              Bootstrap from skills.default (fresh install)"
        ;;
esac
