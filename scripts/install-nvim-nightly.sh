#!/bin/bash
# インストールディレクトリ
installDir="$HOME/opt/neovim/nightly"
# アーカイブ名
nvimNightlyArchive=nvim.tar.gz

# neovim nightlyのURL
nvimNightlyUrl=""
if [[ $OSTYPE == "darwin"* ]]; then
  # MacOs
  if [[ $(uname -m) == "arm64" ]]; then
    # Apple Silicon
    nvimNightlyUrl=https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-arm64.tar.gz
  elif [[ $(uname -m) == "x86_64" ]]; then
    # Intel
    nvimNightlyUrl=https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-x86_64.tar.gz
  fi
elif [[ $OSTYPE == "linux-gnu"* ]] || [[ $OSTYPE == "freebsd"* ]]; then
  # Linux
  nvimNightlyUrl=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
fi

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
