#!/bin/sh
# TODO: 一旦vimscript側で
# git fetch >/dev/null 2>&1

git_status=$(git status)

# pullもpushも無い場合
if echo $git_status | grep -q "Your branch is up to date"; then
  echo 0, 0 | tr -d '\n'
  exit
fi

# pull
if echo $git_status | grep -q "Your branch is behind"; then
  pull=$(echo $git_status | sed -e 's/.*Your branch is.*by //' -e 's/ commit.*//')
  echo $pull, 0 | tr -d '\n'
  exit
fi

# push
if echo $git_status | grep -qE "Your branch is ahead of"; then
  push=$(echo $git_status | sed -e 's/.*Your branch.*by //' -e 's/ commit.*//')
  echo 0, $push | tr -d '\n'
  exit
fi

# pull & push
if echo $git_status | grep -q "Your branch .* have diverged"; then
  pull=$(echo $git_status | sed -e 's/.*and have .* and //' -e 's/ different.*//')
  push=$(echo $git_status | sed -e 's/.*and have //' -e 's/and.*different.*//')
  echo $pull, $push | tr -d '\n'
  exit
fi
