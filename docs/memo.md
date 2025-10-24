# NOTE

## 動作環境

- 基本的に`Neovim nightly`を使用する  
→nightlyのインストールスクリプト: `scripts/install-nvim-nightly.sh`

## Fonts  

- HackGenNerdとか
- icon を設定するときなどは[ここ](https://www.nerdfonts.com/cheat-sheet)見たりとか

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

- diffviewのでブランチ間の差分を確認(プルリク時の確認など)  
本質的にはgitコマンドの使い方

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


## 操作

- g_で改行の手前まで移動  
$と似てるが、visual mode時の挙動が違う。
visual modeで$を押すと、改行位置まで移動してしまう。

- 空白を巻き込みたくないなら`2i"`

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

# indent-rainbow

できそうならvim設定に追加したい。  
結構大変そうだからメモをここにまとめとく。

## 既存プラグイン

- indent-blanklineの設定でそれっぽくできるし、それを使って作られたプラグインとかもある。
ただindent-blanklineベースだと、visual選択したときにインデントハイライトが優先されて見た目が悪い。
- 他にもあったような気はするけど微妙だったと思う。

## 要件

VSCodeのindent-rainbowと同じような挙動

- インデントをレインボー色にhighlightする
- インデントエラーを検知してその箇所を赤くする

## 原理

### インデントをレインボー色にhighlightする

こんな感じでいけるはず

```vim
call clearmatches()
    \ | call matchadd('Indent1', '^\zs\s\ze')
    \ | call matchadd('Indent2', '^\s\zs\s\ze')
    \ | call matchadd('Indent3', '^\s\s\zs\s\ze')
    \ | call matchadd('Indent4', '^\s\s\s\zs\s\ze')
    \ | call matchadd('Indent5', '^\s\s\s\s\zs\s\ze')
    \ | call matchadd('Indent6', '^\s\s\s\s\s\zs\s\ze')
autocmd BufEnter * :highlight! Indent1 guifg=#331f1f guibg=#221f1f
    \ | highlight! Indent2 guifg=#1f331f guibg=#1f221f
    \ | highlight! Indent3 guifg=#33331f guibg=#22221f
    \ | highlight! Indent4 guifg=#331f1f guibg=#221f1f
    \ | highlight! Indent5 guifg=#1f331f guibg=#1f221f
    \ | highlight! Indent6 guifg=#33331f guibg=#22221f
```

### インデントエラーの判定

これはどうしようかな。
とりあえず案は以下。

- (A)行頭の空白をインデントで割り切れるかどうか
- (B)行頭の空白の中で、レインボー色のハイライトに当てはまらない空白があるかどうか

## 必要な処理リスト

- matchadd
    - インデントを取得して動的に定義
    - `autocmd FileType`
- highlight
    - 色は背景色から透過させる
    - `autocmd ColorScheme`

## 懸念点

- パフォーマンス
