- [ ] `autoload/`, `lua/`のディレクトリ構成を変更  
→`core/`と`plugins/`に分ける
  - 現状

```
./
├── autoload/
│   ├── git_info.vim
│   ├── paste_image.vim
│   ├── plugins/
│   ├── terminal.vim
│   └── utils.vim
├── lua/
│   ├── config/
│   ├── const.lua
│   ├── plugins/
│   └── utils.lua
```

  - 変更案

```
./
├── autoload/
│   ├── utils/
│   ├── plugins/
├── lua/
│   ├── const.lua
│   ├── config/
│   ├── plugins/
│   └── utils/
```
