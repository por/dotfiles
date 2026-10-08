#!/bin/sh
# Claude Code status line: branch · context used · 5-hour limit used and reset time

{ read -r dir; read -r usage; } <<JSON
$(jq -r '.workspace.current_dir,
  ([ "ctx \(.context_window.used_percentage // 0 | floor)%" ]
    + (.rate_limits.five_hour as $l | if $l then
        [ "5h \($l.used_percentage | floor)% ↻\($l.resets_at | strflocaltime("%H:%M"))" ]
      else [] end)
    | join(" · "))')
JSON

branch=$(git -C "$dir" branch --show-current 2>/dev/null)
printf '%s\n' "${branch:+$branch · }$usage"
