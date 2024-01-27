#!/bin/sh

branch_name=$(git rev-parse --abbrev-ref HEAD)
# リモートにブランチが無い場合終了
if ! git branch -r | grep -q "origin/${branch_name}"; then
  echo "NO_REMOTE_BRANCH"
  exit
fi

branch_name=$(git rev-parse --abbrev-ref HEAD)

if [ "$branch_name" = "HEAD" ]; then
  commit_hash=$(git rev-parse HEAD)
  echo "DETACHED_HEAD, $commit_hash"
  exit
fi

# 以降、既存の処理...
git_status=$(git status)

# pullもpushも無い場合
if echo $git_status | grep -q "Your branch is up to date"; then
  echo "0, 0"
  exit
fi

# pull
if echo $git_status | grep -q "Your branch is behind"; then
  pull=$(echo $git_status | sed -e 's/.*Your branch is.*by //' -e 's/ commit.*//')
  echo "${pull}, 0"
  exit
fi

# push
if echo $git_status | grep -qE "Your branch is ahead of"; then
  push=$(echo $git_status | sed -e 's/.*Your branch.*by //' -e 's/ commit.*//')
  echo "0, ${push}"
  exit
fi

# pull & push
if echo $git_status | grep -q "Your branch .* have diverged"; then
  pull=$(echo $git_status | sed -e 's/.*and have .* and //' -e 's/ different.*//')
  push=$(echo $git_status | sed -e 's/.*and have //' -e 's/and.*different.*//')
  echo "${pull}, ${push}"
  exit
fi
