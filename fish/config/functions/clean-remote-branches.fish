function clean-remote-branches
  git branch -r --merged | egrep -v "(^\*|master|dev)" | grep -v "origin" | sed 's/origin\///' | xargs -n 1 git push origin --delete
end
