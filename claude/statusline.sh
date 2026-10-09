#!/bin/sh
# Claude Code status line: branch · context used · 5-hour limit used and reset time
# · 7-day limit used, colored when ahead of the week's pace, and reset day and time

# Colors are Claude Code's dark-theme warning and error colors.
{ read -r dir; read -r usage; } <<JSON
$(jq -r 'def color($v; $warn; $crit):
    (if $v >= $crit then "255;107;128" elif $v >= $warn then "255;193;7" else null end) as $rgb
    | if $rgb then "\u001b[38;2;\($rgb)m\(.)\u001b[0m" else . end;
  .workspace.current_dir,
  ((.context_window // {}) as $c | (($c.used_percentage // 0) * ($c.context_window_size // 0) / 100) as $t
    | [ "ctx \("\($t / 1000 | floor)K" | color($t; 100000; 150000))" ]
    + (.rate_limits.five_hour as $l | if $l then
        [ "5h \("\($l.used_percentage | floor)%" | color($l.used_percentage; 70; 90)) ↻\($l.resets_at | strflocaltime("%H:%M"))" ]
      else [] end)
    + (.rate_limits.seven_day as $l | if $l then
        ($l.used_percentage | floor) as $used | ((now - $l.resets_at + 604800) / 6048 | floor) as $pace
        | [ "7d \("\($used)%" | color($used - $pace; 1; 10)) ↻\($l.resets_at | strflocaltime("%a %H:%M"))" ]
      else [] end)
    | join(" · "))')
JSON

branch=$(git -C "$dir" branch --show-current 2>/dev/null)
printf '%s\n' "${branch:+$branch · }$usage"
