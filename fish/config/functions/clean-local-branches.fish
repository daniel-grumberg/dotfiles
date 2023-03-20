function clean-local-branches
  git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d
end
