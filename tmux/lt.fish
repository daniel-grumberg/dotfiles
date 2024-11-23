function _mru_tmux_sessions -d "PRIVATE: list tmux sessions in most recent first order"
  tmux list-sessions -F '#{session_last_attached} #S' | sort --numeric-sort --reverse | awk '{print $2}'
end

function lt -d "List tmux sessions available and that can be started"
  # List non-currently attached sessions
  set tmux_sessions (_mru_tmux_sessions | string collect)
  # Make sure zoxide knows about official projects
  set official_projects (find ~/VersionControlledDocuments -mindepth 2 -maxdepth 2 -type d | string collect)
  for proj in $official_projects
    zoxide add "$proj"
  end
  set zoxide_paths (zoxide query -l | string collect)
  # unique using awk. seen acts as a set of lines
  if test -n "$TMUX"
    set -f current_session_name (tmux display-message -p "#{session_name}")
  end
  echo "$tmux_sessions\n$official_projects\n$zoxide_paths" | awk -v name="$current_session_name" 'BEGIN { seen[name]++ } !seen[$0]++'
end
