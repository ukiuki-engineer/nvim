#!/bin/sh
# TODO: 一旦vimscript側で
# git fetch >/dev/null 2>&1

git_status=$(git status)

# pullもpushも無い場合
if echo $git_status | grep -q "up to date"; then
  echo -n 0, 0
  exit
fi

# pull
if echo $git_status | grep -q "Your branch is behind"; then
  pull=$(echo $git_status | sed -e 's/.*Your branch is.*by //' -e 's/ commit.*//')
  echo -n $pull, 0
  exit
fi

# push
if echo $git_status | grep -qE "Your branch is ahead of"; then
  push=$(echo $git_status | sed -e 's/.*Your branch.*by //' -e 's/ commit.*//')
  echo -n 0, $push
  # echo -n 0, 11
  exit
fi

# pull & push
if echo $git_status | grep -q "Your branch .* have diverged"; then
  pull=$(echo $git_status | sed -e 's/.*and have .* and //' -e 's/ different.*//')
  push=$(echo $git_status | sed -e 's/.*and have //' -e 's/and.*different.*//')
  echo -n $pull, $push
  exit
fi
