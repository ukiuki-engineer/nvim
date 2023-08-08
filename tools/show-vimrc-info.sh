#!/bin/bash
# 結構適当
# 引数に"-startuptime"と入れると、`vim-startuptime -vimpath nvim`を叩く

script_dir=$(dirname $(readlink -f $0))
vimrc_dir=${script_dir/\/tools/}
target='vim$|lua$|toml$|json$' # 行数カウント対象
not_target='colors|not_use'    # 行数カウント対象外

# vim設定行数
printf "%20s%s%5s\n" "vim設定行数" " =" $(
  find $vimrc_dir -type f\
    | grep -E $target\
    | grep -vE $not_target\
    | xargs -I{} cat {}\
    | wc -l
)

# 使用プラグイン数
printf "%20s%s%5s\n" "使用プラグイン数" " =" $(
  cat $vimrc_dir/toml/dein.toml $vimrc_dir/toml/dein_lazy.toml\
    | grep 'repo = '\
    | grep -vE '^#'\
    | wc -l
)

# 起動速度
# NOTE: [vim-startuptime](https://github.com/rhysd/vim-startuptime)をインストールする必要あり
if [[ $* == *-startuptime* ]]; then # 引数なしの場合起動速度測定は実行しない
  command="vim-startuptime -vimpath nvim"
  echo ""
  echo $command
  $command
fi

