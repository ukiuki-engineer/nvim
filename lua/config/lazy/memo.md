# memo

## 画像貼り付けの仕様(paste_image.lua)

- markdown の時のみ有効
- 引数なし

```
:PasteImage
```

と実行すると

```
![Alt text](image-1.png)
```

が挿入され、markdown ファイルと同じディレクトリに clipboard の画像が保存される。

- 引数あり

```
:PasteImage path/filename
```

と実行すると

```
![Alt text](path/filename)
```

が挿入され、指定されたパスに画像が保存される。

- TODO
- [ ] WSL 対応
