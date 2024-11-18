function fzf_git_recent_branch -d "Insert the fzf-selected branch into git commandline"
  git branch --sort=-authordate --format "%(refname:short)"| fzf --query '' | read -z select

  if test -n "$select"
    commandline --insert "$(builtin string trim "$select") "
  end

  commandline -f repaint
end
