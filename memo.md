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

## 根本原理

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
