function t -a name -d "Launch or attach to given tmux session"
  if test -n name
    set -f selected (lt | fzf --filter=$name | head -n 1)
  else
    set -f selected (lt | fzf)
  end

  echo foo $selected
  if test -z "$selected"
    echo "No session was selected"
    return
  end

  echo $selected
  if ! tmux has-session -t=$selected 2> /dev/null
    tmux new-session -ds $selected -c $selected
  end

  if test -n "$TMUX"
    tmux switch-client -t $selected
  else
    tmux attach-session -t $selected
  end
end
