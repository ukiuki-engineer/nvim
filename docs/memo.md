# 環境周り

## 動作環境

- 基本的に`Neovim nightly`を使用する  
→nightlyのインストールスクリプト: `scripts/install-nvim-nightly.sh`

## Fonts  

- HackGenNerdとか
- icon を設定するときなどは[ここ](https://www.nerdfonts.com/cheat-sheet)見たりとか

# vim一般

## 操作

- g_で改行の手前まで移動  
$と似てるが、visual mode時の挙動が違う。
visual modeで$を押すと、改行位置まで移動してしまう。

- 空白を巻き込みたくないなら`2i"`

```vim
d2i"
y2i"
v2i"
```

- `])`で末尾の`)`に移動

```
some_func(arg1, |child_func1(arg2), child_func2(arg3))
                *---------------------------------->|   c]) はここまで削除する
```

- 文字コードを指定して開き直す

```vim
" 例
:e ++enc=sjis
```
## 時々見たいけど忘れがちなヘルプタグ

- `:h key-notation`
- `:h map-table`
- `:h autocmd-events`
- `:h encoding-values`

## lua

- luaでテーブルの中身を見たいときは`vim.print()`

## diff

- 今(分割して)表示してる2ファイルのdiffを取る手順

```vim
:windo diffthis
:set foldlevel=1
```

- 同じディレクトリにある2ファイルなら、そのディレクトリに移動してから`diffsp`した方が早い

```vim
" 1ファイルを開いた状態で
:tcd %:h
:diffsp <比較対象のファイル名>
:set foldlevel=1
```
- 改行コードを無視したい

```vim
" 行末の空白を無視
set diffopt+=iwhiteeol
```

# diffviewのでブランチ間の差分を確認(プルリク時の確認など)  

[基本概念はこれ](#git-diffで2点間の差分を取る)

```vim
" master<-feature-branchにプルリク送る場合
:DiffviewOpen master..feature-branch
" master側に何らか変更あった場合(`...`にすると右側のコミットのみ表示する)
:DiffviewOpen master...feature-branch
" 編集可能にする
:DiffviewOpen master...feature-branch --imply-local
" これでも編集可能だが、master側に何らか変更あった場合は見にくい
:DiffviewOpen master
```

# git-diffで2点間の差分を取る

```
git diff A<結合記号>B
```

- AからBまでの差分  
→A:古、B:新を指定すれば良い
- A,Bはcommit
→ブランチ名を書くと、そのブランチのHEADと解釈される

# `git diff A..B`: 二点間の範囲  

A から B に至るまでに B 側で追加された変更を全て比較。

# `git diff A...B`: マージベース比較  

A と B の共通祖先（merge-base）から見た、B側で追加された変更を比較。  
例えば、masterからfeatureを切ったとして、

```sh
git diff master...feature
```

とすると、
masterで何か変更があっても無視される。

# jdt.ls(このvimを使う上でのメモというより、一般知識としてのメモ)

- jdt.lsは、javaのlsp
- eclipse内の支援ツール`eclipse jdt`を切り出してlsp化したもの
- だから基本的にeclipse以外でも大体eclipseと同じようなことができる
- coc-javaもjdt.lsを使用している

