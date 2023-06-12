" ================================================================================
" 画像貼り付け
" 以下のVSCodeのプラグインを参考にvimに移植した
" https://github.com/mushanshitiancai/vscode-paste-image
" いつかプラグイン化する、かも？
" シェルのコマンドに依存した書き方になってるけど、自分用の内はまーいいかな…
" 今はまだMacOSのみ対応
" ================================================================================
" 2重読み込み防止
if exists('g:vimrc#loaded_paste_image')
  finish
endif
let g:vimrc#loaded_paste_image = 1

" コマンド定義
command! -nargs=* PasteImage :call s:paste_image("<args>")

" nvim-cmpの設定をリロード
lua require("plugins.lsp_and_completion").lua_source_nvim_cmp()

" TODO: 画像が保存されなかった場合、textが挿入されないようにする
function! s:paste_image(args = '') abort
  " Mac以外ならエラー
  if !has('mac')
    echohl ErrorMsg
    echomsg 'This Command can only on MacOS.'
    echohl None
    return
  endif

  " markdownじゃなければエラーメッセージを出力
  if &filetype != 'markdown'
    echohl ErrorMsg
    echomsg 'This command can only be used in Markdown files.'
    echohl None
    return
  endif

  let l:image_dir = ''
  let l:image_filename = ''
  let l:image_fullpath = ''
  let l:insert_text = ''

  " 引数なしの場合
  if a:args == ''
    let l:image_filename = s:seq_filename(getcwd())
    let l:image_fullpath = getcwd() .. '/' .. l:image_filename
    let l:insert_text = '![Alt text](./' .. l:image_filename .. ')'

  " 保存先のディレクトリが指定された場合
  elseif a:args != '' && a:args[len(a:args) - 1] == '/'
    " 絶対パスに変換
    let l:image_dir = fnamemodify(a:args, ':p')

    " 最後がスラッシュなら消す
    if l:image_dir[len(l:image_dir) - 1] == '/'
      let l:image_dir = substitute(l:image_dir, '.$', '', '')
    endif

    " ディレクトリが無ければ作成
    if !isdirectory(l:image_dir)
      call mkdir(l:image_dir, 'p')
    endif
    let l:image_filename = s:seq_filename(l:image_dir)
    let l:image_fullpath = l:image_dir .. '/' .. l:image_filename

  " フルパスが指定された場合
  elseif a:args != '' && a:args[len(a:args) - 1] != '/'
    let l:image_fullpath = fnamemodify(a:args, ':p')
    let l:image_dir = fnamemodify(fnamemodify(l:image_fullpath, ':h'), ':p')
    " ディレクトリが無ければ作成
    if isdirectory(l:image_dir)
      call mkdir(l:image_dir, 'p')
    endif
    let l:image_filename = fnamemodify(l:image_fullpath, ':t')
  endif

  if l:insert_text == ''
    let l:image_relativepath = system('realpath --relative-to="$(pwd)" ' .. l:image_dir .. '| tr -d "\n"') .. '/' .. l:image_filename
    let l:insert_text = '![Alt text](' .. l:image_relativepath .. ')'
  endif

  let l:command = 'osascript ' .. g:init_dir .. '/tools/paste-image.scpt ' .. l:image_fullpath
  echo l:command
  let l:output = system(l:command)
  put =l:insert_text
endfunction

" 連番ファイル名を取得
function! s:seq_filename(target_dir) abort
  let l:files = glob(a:target_dir .. '/image-*.png')
  let l:command = "\\ls " .. a:target_dir .. " | \\grep -E 'image-.*[0-1]*\\.png' | \\sed -e 's/image-//' -e 's/\\.png//' | \\sort -n | \\tail -n1 | tr -d '\n'"
  let l:num = system(l:command)
  return 'image-' .. (l:num + 1) .. '.png'
endfunction
