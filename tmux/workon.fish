function workon --description "Attach or start a tmux session to work on a project"
  argparse --name=workon 'i/internal' 'h/help' -- $argv
  if set -q _flag_help
    echo "\
Usage: workon [OPTIONS] name

Options:
  -i --internal Only search for internal projects
"
    return 0
  end

  set -f name (string trim -c '/' $argv[1])
  set -l paths_to_search ~/VersionControlledDocuments/internal . ~
  if ! set -q _flag_internal
    set -p paths_to_search ~/VersionControlledDocuments/oss
  end

  set -l search_results (find $paths_to_search -name $name -maxdepth 1 -type d -exec realpath {} ';')
  if ! set -q search_results[1]
    echo "Could not find project $name, looked in $paths_to_search"
    return 1
  end

  set -l directory "$search_results[1]"

  # Disambiguate identically named projects based on internal external
  if string match -e "oss" "$directory"
    set -f _name "oss/$name"
  else if string match -e "internal" "$directory"
    set -f _name "internal/$name"
  else
    set -f _name "$name"
  end

  pushd .
  cd "$directory"

  if ! tmux ls 2>/dev/null | grep "$_name"
    tmux new-session -d -s "$_name" -x - -y -
    tmux split-window -t "$_name" -v -c '#{pane_current_path}' -l "25%"
  end

  tmux attach -t "$_name"

  popd
  return 0
end
