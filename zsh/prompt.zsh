zmodload zsh/datetime
autoload -Uz add-zsh-hook

if [[ -n $SSH_CONNECTION || -n $SSH_CLIENT ]]; then
  _prompt_user='%F{cyan}%n@%m%f'
else
  _prompt_user='%F{cyan}%n%f'
fi

# One git status and one git log per prompt. --no-optional-locks keeps the
# prompt from taking index.lock while another git command is running.
_prompt_git_info() {
  _prompt_git=
  local out line oid head dirty
  out=$(git --no-optional-locks status --porcelain=v2 --branch --untracked-files=normal 2>/dev/null) || return

  for line in ${(f)out}; do
    case $line in
      '# branch.oid '*)  oid=${line#\# branch.oid } ;;
      '# branch.head '*) head=${line#\# branch.head } ;;
      '#'*) ;;
      *) dirty=1; break ;;
    esac
  done

  [[ $head == '(detached)' ]] && head=${oid[1,7]}

  local star=green
  [[ -n $dirty ]] && star=red
  _prompt_git=" %F{yellow}(${head//\%/%%}%F{$star}*%f%F{yellow})%f "

  if [[ $oid == '(initial)' ]]; then
    _prompt_git+='%F{cyan}~ %f'
    return
  fi

  local last=$(git log -1 --format=%at 2>/dev/null)
  [[ -n $last ]] || return
  local secs=$(( EPOCHSECONDS - last ))
  local minutes=$(( secs / 60 )) hours=$(( secs / 3600 )) days=$(( secs / 86400 ))

  # Time since the last commit: cyan when clean, otherwise green, yellow after
  # 10 minutes and red after 30
  local color=cyan
  if [[ -n $dirty ]]; then
    if (( minutes > 30 )); then color=red
    elif (( minutes > 10 )); then color=yellow
    else color=green
    fi
  fi

  if (( hours > 24 )); then
    _prompt_git+="%F{$color}${days}d$(( hours % 24 ))h$(( minutes % 60 ))m%f"
  elif (( minutes > 60 )); then
    _prompt_git+="%F{$color}${hours}h$(( minutes % 60 ))m%f"
  else
    _prompt_git+="%F{$color}${minutes}m%f"
  fi
}

_prompt_title() {
  title "zsh" "%m" "%55<...<%~"
}

add-zsh-hook precmd _prompt_title
add-zsh-hook precmd _prompt_git_info

PROMPT='${_prompt_user} %F{green}%c%f${_prompt_git} %F{red}%(!.#.»)%f '
RPROMPT='%F{blue}%~%f%(?.. %F{red}-%?-%f)'
