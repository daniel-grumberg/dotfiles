function _mru_tmux_sessions -d "PRIVATE: list tmux sessions in most recent first order"
  if test -n "$TMUX"
    set -l current_sid (tmux display-message -p "#{session_id}" 2>&1 | grep -v "no server")
  else
    return
  end

  tmux list-sessions \
    -f "#{!=:#{session_id},$current_sid}" \
    -F '#{session_last_attached} #{session_name}' \
    | sort --numeric-sort --reverse | awk '{print $2};'
end

function lt -d "List tmux sessions available and that can be started"
  # List non-currently attached sessions
  set tmux_sessions (_mru_tmux_sessions | string collect)
  # Make sure zoxide knows about official projects
  find ~/VersionControlledDocuments -mindepth 1 -maxdepth 2 -type d | xargs -n 1 zoxide add
  set zoxide_paths (zoxide query -l | string collect)
  # unique using awk. seen acts as a set of lines
  echo "$tmux_sessions\n$zoxide_paths" | awk '!seen[$0]++'
end
