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

# Fetch a skill from a git repo and copy it into the source dir.
# Usage: add_skill <repo-url-or-owner/repo> <skill-name>
add_skill() {
    local repo="$1" skill="$2"

    if [ -z "$repo" ]; then
        echo "Usage: skills add <repo-url> --skill <name>"
        return 1
    fi
    if ! command -v git &> /dev/null; then
        echo "Error: git is required for 'skills add'"
        return 1
    fi

    # Expand owner/repo shorthand to a GitHub URL.
    if [[ "$repo" != *://* && "$repo" =~ ^[^/@:]+/[^/@:]+$ ]]; then
        repo="https://github.com/$repo"
    fi

    local tmp
    tmp=$(mktemp -d) || { echo "Error: cannot create temp dir"; return 1; }

    echo "Cloning $repo ..."
    if ! git clone --depth 1 "$repo" "$tmp/repo" &> /dev/null; then
        echo "Error: failed to clone $repo"
        rm -rf "$tmp"
        return 1
    fi

    # Locate the source folder: a dir named "$skill" containing SKILL.md, or
    # (when no --skill given) the repo root itself if it holds a SKILL.md.
    local src_dir=""
    if [ -n "$skill" ]; then
        src_dir=$(find "$tmp/repo" -type d -name "$skill" \
            -exec test -f '{}/SKILL.md' \; -print 2>/dev/null | head -1)
        if [ -z "$src_dir" ]; then
            echo "Error: skill '$skill' (with a SKILL.md) not found in $repo"
            rm -rf "$tmp"
            return 1
        fi
    elif [ -f "$tmp/repo/SKILL.md" ]; then
        src_dir="$tmp/repo"
        skill=$(basename "$repo" .git)
    else
        echo "Error: no --skill given and repo root has no SKILL.md"
        rm -rf "$tmp"
        return 1
    fi

    local dest="$SKILLS_SRC/$skill"
    if [ -e "$dest" ]; then
        echo "Error: '$skill' already exists at $dest (remove it first to re-add)"
        rm -rf "$tmp"
        return 1
    fi

    cp -R "$src_dir" "$dest" || { echo "Error: copy failed"; rm -rf "$tmp"; return 1; }
    rm -rf "$dest/.git"
    rm -rf "$tmp"

    echo "Added '$skill' to $SKILLS_SRC"
    echo "Enable it by running: skills pick"
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
        echo "Usage: skills <command>"
        echo ""
        echo "Commands:"
        echo "  pick                           Interactive skill picker"
        echo "  add <repo> --skill <name>      Fetch a skill from a git repo into the source dir"
        echo "  init                           Bootstrap from skills.default (fresh install)"
        ;;
    pick)
        interactive_mode
        ;;
    add)
        shift
        repo=""
        skill=""
        while [ $# -gt 0 ]; do
            case "$1" in
                --skill) skill="$2"; [ -n "$skill" ] || { echo "Error: --skill needs a value"; exit 1; }; shift 2 ;;
                --skill=*) skill="${1#*=}"; shift ;;
                *) repo="$1"; shift ;;
            esac
        done
        add_skill "$repo" "$skill"
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
        echo "Usage: skills <command>  (run 'skills' for help)"
        exit 1
        ;;
esac
