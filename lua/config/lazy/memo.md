# memo
## 画像貼り付けの仕様memo
- markdownの時のみ有効
- 引数なし
```
:PasteImage
```
と実行すると
```
![Alt text](image-1.png)
```
が挿入され、markdownファイルと同じディレクトリにclipboardの画像が保存される。

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
 - [ ] WSL対応
