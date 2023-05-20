#!/bin/bash
# 結構適当
# 引数に"-startuptime"と入れると、`vim-startuptime -vimpath nvim`を叩く

# vim設定行数
printf "%20s%s%5s\n" "vim設定行数" " =" $(find .. -type f | grep -E 'vim$|lua$|toml$|json$' | grep -vE 'colors|not_use' | xargs -I{} cat {} | wc -l)

# 使用プラグイン数
printf "%20s%s%5s\n" "使用プラグイン数" " =" $(cat ../toml/dein.toml ../toml/dein_lazy.toml | grep 'repo = ' | grep -vE '^#' | wc -l)

# 起動速度
# NOTE: [vim-startuptime](https://github.com/rhysd/vim-startuptime)をインストールする必要あり
if [[ $* == *-startuptime* ]]; then # 引数なしの場合起動速度測定は実行しない
  command="vim-startuptime -vimpath nvim"
  echo ""
  echo $command
  $command
fi

