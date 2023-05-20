#!/bin/sh
# coc-extensionsのreadmeのシンボリックリンクを`~/coc-extensions-readme/`配下に生成する
# `:CocList extensions`→extensionを選ぶ→`<Tab>`→`h`が上手く機能しないので、応急処置的にこれで対応する

extensions_dir=~/.config/coc/extensions/node_modules
readme_dir=~/coc-extensions-readme

# 既存のリンクを解除
if [ -d "$readme_dir" ]; then
  \ls $feadme_dir | xargs -I{} unlink {}
fi

# readme格納用のディレクトリが中れば作成
if [ ! -d "$readme_dir" ]; then
  mkdir $readme_dir
fi

find $extensions_dir -type f -iname 'readme.md' -maxdepth 2 | while read -r extension_path; do
  # coc-extension名
  extension_name=$(echo $extension_path | sed -e 's/\/readme\.md//I' | xargs -I{} basename {})
  # シンボリックリンクを張る
  ln -s $extension_path $readme_dir/$extension_name.md
done
