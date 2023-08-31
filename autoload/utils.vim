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
" 共通で使うconfirm
"
function! utils#confirm(message) abort
  " Choice number for 'No' selection
  let no_choice_number = 2

  try
    return confirm(a:message, "&Yes\n&No", no_choice_number)
  catch
    " 例外が発生したら2(no)を返す(<C-c>で中断した場合とか)
    return no_choice_number
  endtry
endfunction

"
" git情報(以下の構造を持つグローバル変数)を更新する
"
" g:my#git_infomations  : v:t_dict
"   branch_name         : v:t_string
"   exists_remote_branch: v:t_bool
"   commit_count        : v:t_dict
"     remote            : v:t_string
"     local             : v:t_string
"   has_changed         : v:t_bool
"   config              : v:t_dict
"     user_name         : v:t_string
"     user_email        : v:t_string
"
function! utils#refresh_git_infomations(fetch = v:false) abort
  let g:my#git_infomations = {}

  " git projectではないなら処理終了
  if !v:lua.require('utils').is_git_project()
    return
  endif

  let g:my#git_infomations = {
        \ 'branch_name'         : '',
        \ 'exists_remote_branch': v:false,
        \ 'commit_count'        : {},
        \ 'has_changed'         : {},
        \ 'config'              : {}
        \ }

  " git fetch
  if a:fetch
    try
      call jobstart("git fetch >/dev/null 2>&1")
    catch
      echohl ErrorMsg
      echomsg v:lua.require("const").error_messages("ERROR_EXTERNAL_COMMAND")
      echohl None
    endtry
  endif

  " ブランチ、commit情報 {{{
  try
    let g:my#git_infomations['branch_name'] = v:lua.require('utils').get_branch_name()

    let git_info = v:lua.require('utils').get_git_infomations()
    if git_info != 'NO_REMOTE_BRANCH'
      let g:my#git_infomations['exists_remote_branch'] = v:true
      let parts = split(git_info, ', ')
      let g:my#git_infomations['commit_count']['remote'] = parts[0]
      let g:my#git_infomations['commit_count']['local'] = parts[1]
    endif
  catch
    echohl ErrorMsg
    echomsg v:lua.require("const").error_messages("ERROR_BRANCH_COMMIT_INFO")
    echohl None
  endtry
  " }}}

  " git上の変更があるか {{{
  try
    let g:my#git_infomations['has_changed'] = v:lua.require('utils').has_git_changed()
  catch
    echohl ErrorMsg
    echomsg v:lua.require("const").error_messages("ERROR_GIT_CHANGES")
    echohl None
  endtry
  " }}}

  " user.nameとuser.email {{{
  try
    let g:my#git_infomations['config']['user_name'] = utils#delete_line_breaks(system("git config user.name"))
    let g:my#git_infomations['config']['user_email'] = utils#delete_line_breaks(system("git config user.email"))
  catch
    echohl ErrorMsg
    echomsg v:lua.require("const").error_messages("ERROR_USER_INFO")
    echohl None
  endtry
  " }}}
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
    call timer_start(v:lua.require('const').config("TIMER_START_STANDARD_PLUGINS"), function("s:timer_load"))
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
  if a:spOrVsp == "sp"
  " 水平分割
    split | wincmd j | resize 20
  elseif a:spOrVsp == "vsp"
    " 垂直分割
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

  elseif a:args != '' && a:args[len(a:args) - 1] == '/'
    " 保存先のディレクトリが指定された場合
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

  elseif a:args != '' && a:args[len(a:args) - 1] != '/'
    " フルパスが指定された場合
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

