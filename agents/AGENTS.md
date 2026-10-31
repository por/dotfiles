# Comments

Write a comment only for what the reader cannot recover from the code: a trap, a
non-obvious constraint, a value that came from outside the repo. One or two
lines.

Never comment to justify the decision. If I pushed back, asked for a simpler
approach, or we went a few rounds to get there, none of that belongs in the
file — the argument goes in the commit message, or say it in chat. A comment
that reads like a summary of our conversation is the failure mode; I will ask
for it to be deleted.

Write for someone who has never seen the previous version of the code, and
never mention that version. No "back", "again", "instead of", "no longer",
"used to" — a reader cannot see what changed, so a comment describing the
change is noise to them. Describe the code as it stands and what it constrains.

In component code (`.tsx`), default to no explanatory prose. Doc comments on the
exported component are fine.

When I edit a comment myself, leave it. Only raise it if the new wording is
actually wrong, not merely different from what I would have written.

Labels on a repeated block (design tokens, config entries, enum cases): all or
nothing. A partial set is worse than none.
