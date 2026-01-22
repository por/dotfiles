---
allowed-tools:
- Bash(git status:*)
- Bash(git diff:*)
- Bash(git log:*)
- Bash(git add:*)
- Bash( git commit:*)
- Bash(git push:*)
- Bash(git branch:*)
---
1. First, run 'git diff' to see all changes (both staged and unstaged)
2. Analyze the diff to understand what changed
3. Write a conventional commit message based on the diff:
  - Use format: 'type(scope): description'
  - Types: feat, fix, docs, style, refactor, test, chore
  - Keep the first line under 72 characters
  - Add a blank line and bullet points for details if needed
  - Never mention Claude Code
4. Stage all changes with 'git add -A'
5. Commit with the conventional commit message
