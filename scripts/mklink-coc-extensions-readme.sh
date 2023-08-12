#!/bin/sh
# NOTE: coc.nvim側がbug fixされこのスクリプトは必要なくなったので基本的に不使用
# coc-extensionsのreadmeのシンボリックリンクを`~/coc-extensions-readme/`配下に生成する
# `:CocList extensions`→extensionを選ぶ→`<Tab>`→`h`が上手く機能しないので、応急処置的にこれで対応する

extensions_dir=~/.config/coc/extensions/node_modules
readme_dir=~/coc-extensions-readme

if [ -d "$readme_dir" ]; then
  # 既存のリンクを解除
  find $readme_dir -type l | xargs -I{} unlink {}
else
  # ディレクトリが無ければ作成
  mkdir $readme_dir
fi

find $extensions_dir -maxdepth 2 -type f -iname 'readme.md'\
  | while read -r extension_path; do # readmeファイルごとに処理
    # coc-extension名
    extension_name=$(
      echo $extension_path\
        | sed -e 's/\/readme\.md//I'\
        | xargs -I{} basename {}
    )
    # シンボリックリンクを張る
    ln -s $extension_path $readme_dir/$extension_name.md
  done
