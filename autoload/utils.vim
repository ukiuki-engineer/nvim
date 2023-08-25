" ================================================================================
" vimscriptで書いた処理はここに集める
" ================================================================================
" --------------------------------------------------------------------------------
" utils
" --------------------------------------------------------------------------------
"
" 改行を削除する
"
function! utils#delete_line_breaks(str) abort
  return substitute(a:str, '\n', '', 'g')
endfunction

"
" g:git_commit_status, g:git_configを更新する
"
function! utils#refresh_git_infomations(fetch = v:false) abort
  " git projectではないなら処理終了
  if !v:lua.require('utils').is_git_project()
    return
  endif

  " git fetch
  if a:fetch
    try
      call jobstart("git fetch >/dev/null 2>&1")
    catch
      echohl ErrorMsg
      echomsg "An error occurred while executing the external command."
      echohl None
    endtry
  endif

  let script_path = g:init_dir .. '/scripts/commit_status.sh'
  let sh_output = utils#delete_line_breaks(system(script_path))

  if sh_output == 'NO_REMOTE_BRANCH'
    let g:git_commit_status = 'NO_REMOTE_BRANCH'
  else
    let parts = split(sh_output, ', ')
    let g:git_commit_status = {}
    let g:git_commit_status['remote'] = parts[0]
    let g:git_commit_status['local'] = parts[1]
  endif

  " user.nameとuser.email
  let g:git_config = {}
  let g:git_config['user_name'] = utils#delete_line_breaks(system("git config user.name"))
  let g:git_config['user_email'] = utils#delete_line_breaks(system("git config user.email"))
endfunction

"
"
"
function! utils#remote_branch_info_text() abort
  if !exists('g:git_commit_status')
    return ""
  endif

  let is_dict = type(g:git_commit_status) != v:t_dict
  let is_no_remote_branch = is_dict && g:git_commit_status == 'NO_REMOTE_BRANCH'

  if is_no_remote_branch
    return ""
  else
    return ""
  endif
endfunction

"
" commit数の状態のテキストを返す
"
function! utils#git_commit_status_text() abort
  let remote_branch_info_text = utils#remote_branch_info_text()

  if remote_branch_info_text != ""
    return ""
  elseif g:git_commit_status['remote'] == "" && g:git_commit_status['local'] == ""
    return ""
  else
    return "↓" .. g:git_commit_status['remote'] .. " ↑" .. g:git_commit_status['local']
  endif
endfunction
" --------------------------------------------------------------------------------
" lua/config/init.lua
" --------------------------------------------------------------------------------
"
" 標準プラグインの遅延読み込み
"
function! utils#lazy_load() abort
  augroup MyTimerLoad
    autocmd!
    execute 'au InsertLeave,FileType * ++once call s:packadd()'
  augroup END
  if expand('%') != ''
    call timer_start(500, function("s:timer_load"))
  endif
endfunction

function! s:packadd() abort
  unlet g:loaded_matchit
  packadd matchit
endfunction

function! s:timer_load(timer) abort
  call s:packadd()
endfunction
" --------------------------------------------------------------------------------
" lua/config/lazy/terminal.lua
" --------------------------------------------------------------------------------
"
" ターミナルをカレントバッファのディレクトリで開く
"
function! utils#term_here(spOrVsp) abort
  " 水平分割
  if a:spOrVsp == "sp"
    split | wincmd j | resize 20
  " 垂直分割
  elseif a:spOrVsp == "vsp"
    vsplit | wincmd l
  endif
  " ターミナルを開く
  call utils#execute_here("terminal")
endfunction

"
" カレントバッファのディレクトリに移動してコマンドを実行
"
function! utils#execute_here(command) abort
  " 無名バッファでなければ移動
  if expand('%') != ''
    lcd %:h
  endif
  " コマンド実行
  execute a:command
endfunction
" --------------------------------------------------------------------------------
" lua/config/lazy/commands.lua
" --------------------------------------------------------------------------------
"
" カーソル行/列の表示と非表示
"
function! utils#set_cursor_line_column() abort
  " カーソル行/列を表示
  setlocal cursorline cursorcolumn
  augroup MyCursorLineColumn
    autocmd!
    " カーソル行/列を非表示
    autocmd WinLeave,CursorMoved <buffer> ++once setlocal nocursorline nocursorcolumn
  augroup END
endfunction

" --------------------------------------------------------------------------------
" lua/config/lazy/paste_image.lua
" --------------------------------------------------------------------------------
"
" 画像の貼り付け
"
function! utils#paste_image(args = '') abort
  " TODO: 画像が保存されなかった場合、textが挿入されないようにする
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
    let l:image_filename = utils#seq_filename(getcwd())
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
    let l:image_filename = utils#seq_filename(l:image_dir)
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

  let l:command = 'osascript ' .. g:init_dir .. '/scripts/paste-image.scpt ' .. l:image_fullpath
  echo l:command
  let l:output = system(l:command)
  put =l:insert_text
endfunction

"
" 連番ファイル名を取得
"
function! utils#seq_filename(target_dir) abort
  let l:files = glob(a:target_dir .. '/image-*.png')
  let l:command = "\\ls " .. a:target_dir .. " | \\grep -E 'image-.*[0-1]*\\.png' | \\sed -e 's/image-//' -e 's/\\.png//' | \\sort -n | \\tail -n1 | tr -d '\n'"
  let l:num = system(l:command)
  return 'image-' .. (l:num + 1) .. '.png'
endfunction

