#!/bin/sh
# vim設定行数
find . -type f | grep -E 'vim$|lua$|toml$|json$' | grep -vE 'colors|not_use' | xargs -I{} cat {} | wc -l
# 使用プラグイン数
cat toml/dein.toml toml/dein_lazy.toml | grep 'repo = ' | grep -vE '^#' | wc -l
# 起動速度
# NOTE: [vim-startuptime](https://github.com/rhysd/vim-startuptime)をインストールする必要あり
vim-startuptime -vimpath nvim
