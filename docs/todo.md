# TODO
## markdownでラフに数式を書いて表示させる環境を作る  

### TODO

- [x] texのスニペットが使える
- [ ] texのsyntax highlightが効く
- [ ] 自動化
  - [ ] コンパイル
  - [ ] viewer起動
- [ ] おまじない部分をスニペット化
  - [ ] 普通の日本語文章
  - [ ] 画像化用に、余白部分が全カットされてるversion

### 現状のsample

#### コード

```markdown
---
title: "タイトル"
documentclass: ltjsarticle
classoption:
  - 11pt
  - a4paper
---

# これはテストです。

インライン数式：$E = mc^2$

$$
R_{\mu\nu} - \frac{1}{2} R g_{\mu\nu}
= \frac{8\pi G}{c^4} T_{\mu\nu}
$$

# test

## test
```

#### コンパイルコマンド

```sh
pandoc test.md -o test.pdf --pdf-engine=lualatex
```

