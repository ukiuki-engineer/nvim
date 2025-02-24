#!/bin/bash
#
# Neovim nightlyのインストールスクリプト
#

# エラー発生時はスクリプトを停止する
set -e

# インストールディレクトリ
installDir="$HOME/opt/neovim/nightly"
# old
oldDir="${installDir}-old"
# アーカイブ名
nvimNightlyArchive=nvim.tar.gz
# neovim nightlyのURL
nvimNightlyUrl=""

# Neovim NightlyのダウンロードURLを設定
function _set_nvim_url() {
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

  # URLが空の場合はエラーを出力して終了
  if [[ -z $nvimNightlyUrl ]]; then
    echo "Error: URL for downloading Neovim nightly build is not set."
    exit 1
  fi
}

# Neovim Nightlyのバックアップとインストール
function _install() {
  # バックアップ
  rm -rf $oldDir
  mv $installDir $oldDir
  # インストールディレクトリ作成
  mkdir -p $installDir
  # ダウンロード
  wget -O $nvimNightlyArchive $nvimNightlyUrl

  # ダウンロードに失敗した場合はエラーを出力して終了
  if [[ $? -ne 0 ]]; then
    echo "Error: Failed to download Neovim nightly."
    exit 1
  fi

  # アーカイブを展開
  tar xzvf $nvimNightlyArchive -C $installDir --strip-components=1
  # アーカイブは不要なので削除
  rm $nvimNightlyArchive

  echo "Neovim Nightly has been installed"
}

#
# 確認メッセージを表示する
# Parameters:
#   - $1: 確認メッセージ
_confirm() {
  echo -n "$1 (y/n)"
  read -r reply
  echo # 改行
  if [[ $reply =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

function main() {
  if ! _confirm "Do you want to install Neovim Nightly?"; then
    exit 0
  fi
  _set_nvim_url
  _install
}

main
