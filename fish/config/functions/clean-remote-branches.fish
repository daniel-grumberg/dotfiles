function clean-remote-branches
  git branch -r --merged | egrep -v "(^\*|master|dev)" | sed 's/origin\///' | xargs -n 1 git push origin --delete
end
