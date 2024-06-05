# NOTE

- Fonts  
  - HackGenNerdとか
  - icon を設定するときなどは[ここ](https://www.nerdfonts.com/cheat-sheet)見たりとか
- 時々見たいけど忘れがちなヘルプタグ
    - `:h key-notation`
    - `:h map-table`
    - `:h autocmd-events`
    - `:h encoding-values`
- luaでテーブルの中身を見たいときは`vim.print()`
- 基本的に`Neovim nightly`を使用する  
    →nightlyのインストールスクリプト: `scripts/install-nvim-nightly.sh`
- diff
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

- g_で改行の手前まで移動  
  $と似てるが、visual mode時の挙動が違う。
  visual modeで$を押すと、改行位置まで移動してしまう。

- 空白を巻き込みたくないなら`2i"`

- `])`で末尾の`)`に移動

```
some_func(arg1, |child_func1(arg2), child_func2(arg3))
                *---------------------------------->|   c]) はここまで削除する
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
