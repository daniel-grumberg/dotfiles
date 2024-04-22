function workon --description "Attach or start a tmux session to work on a project" --argument name
  set -f name (string trim -c '/' $name)
  if tmux ls 2>/dev/null | grep "$dir"
    tmux attach -t "$dir"
  else
    # Find a directory of the right name in the right spot to start the session in.
    # First search there as it will speed up the search in the common case
    for dir in (find ~/VersionControlledDocuments/{internal,oss} . ~ -name "$name" -maxdepth 1 -exec realpath {} ";" -quit)
      if test -d "$dir"
        pushd .
        cd "$dir"
        tmux new-session -d -s "$name" -x - -y -
        tmux split-window -t "$name" -v -c '#{pane_current_path}' -l "25%"
        tmux attach -t "$name"
        popd
        return 0
      end
    end
  end
  return 1
end
