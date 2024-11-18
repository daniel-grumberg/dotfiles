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
  _mru_tmux_sessions
  # Make sure zoxide knows about official projects
  find ~/VersionControlledDocuments -mindepth 1 -maxdepth 2 -type d | xargs -n 1 zoxide add
  zoxide query -l
end
