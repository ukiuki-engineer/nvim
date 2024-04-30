#!/bin/bash
# インストールディレクトリ
installDir="$HOME/opt/neovim-nightly"
# neovim nightlyのURL
# TODO: Mac用の分岐も用意する
nvimNightlyUrl=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
# アーカイブ名
nvimNightlyArchive=nvim.tar.gz

# 既存のインストールディレクトリを削除
rm -rf $installDir
# インストールディレクトリ作成
mkdir -p $installDir
# ダウンロード
wget -O $nvimNightlyArchive $nvimNightlyUrl
# アーカイブを展開
tar xzvf $nvimNightlyArchive -C $installDir --strip-components=1
# アーカイブは不要なので削除
rm $nvimNightlyArchive

echo "Neovim Nightly has been installed"
