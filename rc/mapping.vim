" ================================================================================
" mapping.vim
" TODO: BufReadとInsertEnterで遅延ロードするように
" ================================================================================
let g:mapleader = "m"
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
nnoremap <silent> <TAB> :bn<CR>
nnoremap <silent> <S-TAB> :bN<CR>
nnoremap <C-j> 7j
nnoremap <C-k> 7k
vnoremap <C-j> 7j
vnoremap <C-k> 7k
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>
" TODO: 全角文字を配列に入れてforで回す {{{
" f{全角文字}
nnoremap <leader>f, f、
nnoremap <leader>f. f。
nnoremap <leader>f( f（
nnoremap <leader>f) f）
nnoremap <leader>f[ f「
nnoremap <leader>f] f」
nnoremap <leader>fa fあ
nnoremap <leader>fi fい
nnoremap <leader>fu fう
nnoremap <leader>fe fえ
nnoremap <leader>fo fお
" t{全角文字}
nnoremap <leader>t, t、
nnoremap <leader>t. t。
nnoremap <leader>t( t（
nnoremap <leader>t) t）
nnoremap <leader>t[ t「
nnoremap <leader>t] t」
nnoremap <leader>ta tあ
nnoremap <leader>ti tい
nnoremap <leader>tu tう
nnoremap <leader>te tえ
nnoremap <leader>to tお
" df{全角文字}
nnoremap <leader>df, df、
nnoremap <leader>df. df。
nnoremap <leader>df( df（
nnoremap <leader>df) df）
nnoremap <leader>df[ df「
nnoremap <leader>df] df」
nnoremap <leader>dfa dfあ
nnoremap <leader>dfi dfい
nnoremap <leader>dfu dfう
nnoremap <leader>dfe dfえ
nnoremap <leader>dfo dfお
" dt{全角文字}
nnoremap <leader>dt, dt、
nnoremap <leader>dt. dt。
nnoremap <leader>dt( dt（
nnoremap <leader>dt) dt）
nnoremap <leader>dt[ dt「
nnoremap <leader>dt] dt」
nnoremap <leader>dta dtあ
nnoremap <leader>dti dtい
nnoremap <leader>dtu dtう
nnoremap <leader>dte dtえ
nnoremap <leader>dto dtお
" yf{全角文字}
nnoremap <leader>yf, yf、
nnoremap <leader>yf. yf。
nnoremap <leader>yf( yf（
nnoremap <leader>yf) yf）
nnoremap <leader>yf[ yf「
nnoremap <leader>yf] yf」
nnoremap <leader>yfa yfあ
nnoremap <leader>yfi yfい
nnoremap <leader>yfu yfう
nnoremap <leader>yfe yfえ
nnoremap <leader>yfo yfお
" yt{全角文字}
nnoremap <leader>yt, yt、
nnoremap <leader>yt. yt。
nnoremap <leader>yt( yt（
nnoremap <leader>yt) yt）
nnoremap <leader>yt[ yt「
nnoremap <leader>yt] yt」
nnoremap <leader>yta ytあ
nnoremap <leader>yti ytい
nnoremap <leader>ytu ytう
nnoremap <leader>yte ytえ
nnoremap <leader>yto ytお
" }}}

