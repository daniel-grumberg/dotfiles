if status is-interactive
  fzf --fish | source
end
set --query FZF_DEFAULT_OPTS FZF_DEFAULT_OPTS_FILE
if test $status -eq 2
  # cycle allows jumping between the first and last results, making scrolling faster
  # layout=reverse lists results top to bottom, mimicking the familiar layouts of git log, history, and env
  # border shows where the fzf window begins and ends
  # height=90% leaves space to see the current command and some scrollback, maintaining context of work
  # preview-window=wrap wraps long lines in the preview window, making reading easier
  # marker=* makes the multi-select marker more distinguishable from the pointer (since both default to >)
  set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
end
