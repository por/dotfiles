#!/bin/bash
# Manage agent skills via symlinks in a central state directory.
# App-specific sync scripts consume the state to populate their own config folders.

SKILLS_SRC="$HOME/.dotfiles/agents/skills"
SKILLS_STATE="$HOME/.dotfiles/agents/skills-enabled"
DEFAULT_FILE="$HOME/.dotfiles/agents/skills.default"

mkdir -p "$SKILLS_STATE" || { echo "Error: Cannot create $SKILLS_STATE" >&2; exit 1; }

is_enabled() {
    [ -L "$SKILLS_STATE/$1" ]
}

enable_skill() {
    local skill="$1"
    if [ ! -d "$SKILLS_SRC/$skill" ]; then
        echo "Error: Skill '$skill' not found in $SKILLS_SRC"
        return 1
    fi
    ln -sfn "$SKILLS_SRC/$skill" "$SKILLS_STATE/$skill"
}

disable_skill() {
    rm -f "$SKILLS_STATE/$1"
}

sync_all() {
    # Find and run app-specific sync scripts, if any.
    # Each script should read from $HOME/.dotfiles/agents/skills-enabled.
    find "$HOME/.dotfiles" -name sync -type f -print0 | while IFS= read -r -d '' script; do
        /bin/bash "$script"
    done
}

interactive_mode() {
    if ! command -v gum &> /dev/null; then
        echo "gum not found. Install it with: brew install gum"
        exit 1
    fi

    # Build arrays of all skills and currently enabled skills
    local skills=()
    local selected_args=()

    for d in "$SKILLS_SRC"/*/; do
        [ -d "$d" ] || continue
        name=$(basename "$d")
        skills+=("$name")
        if is_enabled "$name"; then
            selected_args+=("--selected" "$name")
        fi
    done

    if [ ${#skills[@]} -eq 0 ]; then
        echo "No skills found in $SKILLS_SRC"
        exit 0
    fi

    # Run gum choose with multi-select
    selected=$(gum choose \
        --no-limit \
        --header "Select skills (space to toggle, enter to confirm):" \
        --cursor "> " \
        --cursor-prefix "○ " \
        --selected-prefix "● " \
        --unselected-prefix "○ " \
        "${selected_args[@]}" \
        "${skills[@]}")

    # Handle cancel (Ctrl+C or escape)
    if [ $? -ne 0 ]; then
        echo "Cancelled."
        exit 0
    fi

    # Convert selected output to array
    local new_enabled=()
    while IFS= read -r line; do
        [ -n "$line" ] && new_enabled+=("$line")
    done <<< "$selected"

    # Sync state: enable newly selected, disable newly deselected
    for skill in "${skills[@]}"; do
        local is_selected=false
        for s in "${new_enabled[@]}"; do
            [ "$s" = "$skill" ] && is_selected=true && break
        done

        if $is_selected && ! is_enabled "$skill"; then
            enable_skill "$skill"
            echo "Enabled: $skill"
        elif ! $is_selected && is_enabled "$skill"; then
            disable_skill "$skill"
            echo "Disabled: $skill"
        fi
    done

    sync_all
}

case "$1" in
    ""|"--help"|"-h")
        if [ -z "$1" ]; then
            interactive_mode
        else
            echo "Usage: skills [init]"
            echo ""
            echo "Commands:"
            echo "  (no args)   Interactive skill picker"
            echo "  init        Bootstrap from skills.default (fresh install)"
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
        for link in "$SKILLS_STATE"/*; do
            [ -L "$link" ] && has_skills=true && break
        done

        if $has_skills; then
            echo "Skills already configured, skipping bootstrap"
            exit 0
        fi

        echo "Bootstrapping skills from skills.default..."
        while IFS= read -r skill || [ -n "$skill" ]; do
            skill=$(echo "$skill" | xargs)  # trim whitespace first
            # Skip comments and empty lines
            [[ "$skill" =~ ^#.*$ || -z "$skill" ]] && continue
            if enable_skill "$skill"; then
                echo "  Enabled: $skill"
            fi
        done < "$DEFAULT_FILE"

        sync_all
        ;;
    *)
        echo "Usage: skills [init]"
        exit 1
        ;;
esac
