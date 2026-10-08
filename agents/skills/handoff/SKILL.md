---
name: handoff
description: Write a brief prompt that lets a fresh session pick up the current work, and copy it to the clipboard. Use when the user asks for a handoff or handover prompt, says the context is getting long, or wants to continue in a new session.
---

# Handoff

Write a prompt for a new session that knows nothing about this conversation. It
should be able to continue the work without re-asking what was settled here.

## Before writing

Check the real state rather than recalling it: `git status`, the current branch
and its base, what is committed and pushed, and whether lint, typecheck and
build last passed.

## Format

Start with one line naming the goal, including ticket ids if there are any.
Then only the sections that have content:

```markdown
Continue <goal> (ticket <id>) in <repo>.

## State
- Branch `<branch>` off `<base>`; <committed/pushed/uncommitted>. <Which checks pass.>
- <Constraints the user set: scope, style rules, things to avoid.>

## Decisions
- <What was decided and why, where the next session might otherwise reopen it.>

## How it works
- <Only what the code doesn't make obvious: where the pieces live and how they connect.>

## Next
1. <The next concrete step.>

## Open questions for the user
1. <Anything still waiting on the user.>

## Known, not ours
- <Pre-existing problems the next session should not chase.>
```

## Rules

- Keep it brief. Leave out anything the next session can learn by reading the
  diff or the repo's docs. Point to the files instead.
- Record decisions the user made and corrections they gave. Those are what get
  lost between sessions.
- Name files, branches, commands and values exactly.
- Don't summarize the conversation or narrate how you got here.

## Deliver

Print the prompt in a single fenced `markdown` block, then copy it with
`pbcopy` and say that it is on the clipboard.
