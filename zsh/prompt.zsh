autoload colors && colors

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  GIT_PROMPT_PREFIX=" %F{yellow}("
  GIT_PROMPT_SUFFIX="%F{yellow})%f "
  GIT_PROMPT_CLEAN="%F{green}*%f"
  GIT_PROMPT_DIRTY="%F{red}*%f"
  GIT_PROMPT_UNTRACKED="%F{cyan}*%f"

  if $(! $git status -s &> /dev/null)
  then
    echo ""
  else
    if [[ $($git status --porcelain) == "" ]]
    then
      echo "$GIT_PROMPT_PREFIX$(git_prompt_info)$GIT_PROMPT_CLEAN$GIT_PROMPT_SUFFIX"
    else
      echo "$GIT_PROMPT_PREFIX$(git_prompt_info)$GIT_PROMPT_DIRTY$GIT_PROMPT_SUFFIX"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo " "
  else
    echo "%{$fg[yellow]%}[%{$reset_color%}%{$fg[red]%}unpushed%{$reset_color%}%{$fg[yellow]%}]%{$reset_color%} "
  fi
}

directory_name() {
  echo "%F{cyan}%n@%m%f %F{green}%c%f"
}

function git_time_since_commit() {
  TIME_SINCE_COMMIT_SHORT="%F{green}"
  TIME_SHORT_COMMIT_MEDIUM="%F{yellow}"
  TIME_SINCE_COMMIT_LONG="%F{red}"
  TIME_SINCE_COMMIT_NEUTRAL="%F{cyan}"

  if git rev-parse --git-dir > /dev/null 2>&1; then
    # Only proceed if there is actually a commit.
    if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
      # Get the last commit.
      last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
      now=`date +%s`
      seconds_since_last_commit=$((now-last_commit))

      # Totals
      MINUTES=$((seconds_since_last_commit / 60))
      HOURS=$((seconds_since_last_commit/3600))

      # Sub-hours and sub-minutes
      DAYS=$((seconds_since_last_commit / 86400))
      SUB_HOURS=$((HOURS % 24))
      SUB_MINUTES=$((MINUTES % 60))

      if [[ -n $(git status -s 2> /dev/null) ]]; then
        if [ "$MINUTES" -gt 30 ]; then
          COLOR="$TIME_SINCE_COMMIT_LONG"
        elif [ "$MINUTES" -gt 10 ]; then
          COLOR="$TIME_SHORT_COMMIT_MEDIUM"
        else
          COLOR="$TIME_SINCE_COMMIT_SHORT"
        fi
      else
        COLOR="$TIME_SINCE_COMMIT_NEUTRAL"
      fi

      if [ "$HOURS" -gt 24 ]; then
        echo "$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%f"
      elif [ "$MINUTES" -gt 60 ]; then
        echo "$COLOR${HOURS}h${SUB_MINUTES}m%f"
      else
        echo "$COLOR${MINUTES}m%f"
      fi
    else
      COLOR="$TIME_SINCE_COMMIT_NEUTRAL"
      echo "$COLOR~ "
    fi
  fi
}

function check_last_exit_code() {
  local LAST_EXIT_CODE=$?
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    local EXIT_CODE_PROMPT=' '
    EXIT_CODE_PROMPT+="%F{red}-%f"
    EXIT_CODE_PROMPT+="%F{red}$LAST_EXIT_CODE%f"
    EXIT_CODE_PROMPT+="%F{red}-%f"
    echo "$EXIT_CODE_PROMPT"
  fi
}

function prompt_char {
  echo " %F{red}%(!.#.»)%f "
}

export PROMPT=$'$(directory_name)$(git_dirty)$(git_time_since_commit)$(prompt_char)'

set_prompt () {
  export RPROMPT=$'%F{cyan}%~%f$(check_last_exit_code)'
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
