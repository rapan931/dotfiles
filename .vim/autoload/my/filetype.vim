" REF: that wrote someone's vimrc. forget..
function! my#filetype#setting(ftype) abort
  let ftype = my#s(a:ftype, '-', '_')
  if !empty(ftype) && exists('*' . 'my#filetype#' . ftype)
    execute 'call my#filetype#' . ftype . '()'
  else
    call s:set_indent(2, 0)
  endif
endfunction

function! s:set_indent(tab_length, is_hard_tab) abort
  if a:is_hard_tab
    setlocal noexpandtab
  else
    setlocal expandtab
  endif
  let &l:shiftwidth  = a:tab_length
  let &l:softtabstop = a:tab_length
  let &l:tabstop     = a:tab_length
endfunction

function! my#filetype#xxd() abort
  setlocal binary
  %!xxd -g 4
endfunction

function! my#filetype#css() abort
  call s:set_indent(4, 0)

  " 末尾にセミコロンを入力して次の行に移る
  imap <buffer> <C-CR> <C-e>;<CR>
endfunction

function! my#filetype#vim() abort
  " 明示的に \ を付けて改行する
  imap <C-CR> <Plug>(my-back-slash-linefeed)
endfunction

function! my#filetype#html() abort
  call s:set_indent(4, 0)
  call s:emmet_mapping()
endfunction

function! my#filetype#markdown() abort
  " call asyncomplete#disable_for_buffer()
endfunction

function! my#filetype#txt() abort
  " call asyncomplete#disable_for_buffer()
endfunction

function! my#filetype#javascript() abort
  call s:set_indent(4, 0)
  " 末尾にセミコロンを入力して次の行に移る
  inoremap <buffer> <C-CR> <End>;<CR>
  inoremap <buffer> jk <End>;
  " nnoremap <buffer> Q A;
endfunction

function! my#filetype#cpp() abort
  call s:set_indent(4, 0)
endfunction

function! my#filetype#c() abort
  call my#filetype#cpp()
endfunction

function! my#filetype#gitconfig() abort
  call s:set_indent(4, 1)
endfunction

function! my#filetype#gitcommit() abort
  setlocal spell
endfunction

function! my#filetype#help() abort
  " qで閉じる
  nnoremap <buffer> q ZZ
endfunction

function! my#filetype#unite() abort
  call my#plug#unite_vimfiler#unite_mapping()
endfunction

function! my#filetype#vimfiler() abort
  call my#plug#unite_vimfiler#vimfiler_mapping()
endfunction

function! my#filetype#fern() abort
  " nmap <silent><buffer> h
  nmap <silent><buffer> <CR> <Plug>(fern-action-open:select)
  nmap <silent><buffer> l    <Plug>(fern-action-expand)
  nmap <silent><buffer> h    <Plug>(fern-action-collapse)
  " nmap <buffer><nowait> x <Plug>(fern-action-open:system)
  " nmap ..... <Plug>(fern-action-terminal:select)
endfunction

" function! my#filetype#denite() abort
"   nnoremap <buffer><expr> <CR> denite#do_map('do_action')
"   nnoremap <buffer><expr> d denite#do_map('do_action', 'delete')
"   nnoremap <buffer><expr> p denite#do_map('do_action', 'preview')
"   nnoremap <buffer><expr> q denite#do_map('quit')
"   nnoremap <buffer><expr> i denite#do_map('open_filter_buffer')
"   nnoremap <buffer><expr> a denite#do_map('open_filter_buffer')
"   nnoremap <buffer><expr> <Space> denite#do_map('toggle_select').'j'
" endfunction
"
" function! my#filetype#denite_filter() abort
"   inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
"   inoremap <silent><buffer><expr> <C-j> denite#do_map('do_action')
"
"   imap     <silent><buffer> <Esc> <Plug>(denite_filter_quit)
" endfunction

function! my#filetype#godoc() abort
  " qで閉じる
  nnoremap <buffer> q ZZ

endfunction

" REF: http://thinca.hatenablog.com/entry/20130708/1373210009
function! my#filetype#qf() abort
  setlocal nocursorline

  " 一番下に表示
  wincmd J

  " qで閉じる
  nnoremap <buffer> q ZZ

  " <CR>はqfのCRに戻す
  nnoremap <buffer> <CR> <CR>

  " pでプレビューっぽく動作、C-j/C-Kでプレビューっぽく動作した後カーソル移動
  nnoremap <buffer> p <CR>zz<C-w>p
  nnoremap <buffer> <C-k> k<CR>zrzz<C-w>p
  nnoremap <buffer> <C-j> j<CR>zrzz<C-w>p

  " vim-qfedit入れて編集できるようになったけど、
  " 空業追加とか一文字の編集とかしないように気づいたマップはNOPに
  nnoremap <buffer> a <NOP>
  nnoremap <buffer> A <NOP>
  nnoremap <buffer> i <NOP>
  nnoremap <buffer> I <NOP>
  nnoremap <buffer> r <NOP>
  nnoremap <buffer> R <NOP>
  nnoremap <buffer> gR <NOP>
  nnoremap <buffer> x <NOP>
  nnoremap <buffer> o <NOP>
  nnoremap <buffer> O <NOP>
  noremap  <buffer> c <NOP>
  noremap  <buffer> C <NOP>
  noremap  <buffer> > <NOP>
  noremap  <buffer> < <NOP>
  noremap  <buffer> <C-x> <NOP>
  noremap  <buffer> <C-a> <NOP>
  noremap  <buffer> + <NOP>
  noremap  <buffer> - <NOP>
endfunction

function! my#filetype#go() abort
  " if executable('gopls')
  "   setlocal omnifunc=lsp#complete
  "   nmap gd <plug>(lsp-definition)
  " endif

  call s:set_indent(4, 1)

  nnoremap <buffer> <Leader><Leader>r :<C-u>!go build -o %:r.exe %<CR>
  nnoremap <buffer> <Leader><Leader>R :<C-u>!go build -o %:r.exe % && %:r.exe<CR>
  xnoremap <buffer> <Leader>R :<C-u>echo 'no map'<CR>

  " vim-go/ftplugin/go.vim
  nnoremap <buffer> <silent> gd :GoDef<cr>
  nnoremap <buffer> <silent> <C-]> :GoDef<cr>
  nnoremap <buffer> <silent> <C-t> :<C-U>call go#def#StackPop(v:count1)<cr>

  " for Tour of Go
  nnoremap <buffer> <Space><Space> :<C-u>call my#filetype#go_comment_for_tour_of_go('\_.*\_^\s*\/\/\zs', 'n', '\%' . line('$') . 'l', 'n')<CR>
endfunction

function! my#filetype#calendar() abort
  setlocal synmaxcol&
endfunction

function! my#filetype#go_comment_for_tour_of_go(search1, search1_flgs, search2, search2_flgs) abort
  if &runtimepath !~ 'caw.vim'
    call my#error_msg('not found caw.vim!')
    return
  endif

  let line1 = search(a:search1, a:search1_flgs)
  let line2 = search(a:search2, a:search2_flgs)

  if line1 == 0 || line2 == 0
    my#error_msg('not found specified strings!')
    return
  endif

  execute line1 . 'y'

  call setpos("'<", [bufnr('%'), line1, 0, 0])
  call setpos("'>", [bufnr('%'), line2, 0, 0])
  call caw#keymapping_stub('x', 'hatpos', 'comment')

  execute 'normal!' "Go\<Esc>p\<C-a>"
endfunction

function s:emmet_mapping() abort
  imap <silent><buffer> <C-j>,  <Plug>(emmet-expand-abbr)

  " REF: https://github.com/mattn/emmet-vim/issues/506
  call submode#enter_with('emmet-n', 'i', 'rb', '<C-j>n', '<Plug>(emmet-move-next)')
  call submode#enter_with('emmet-n', 'i', 'rb', '<C-j>N', '<Plug>(emmet-move-prev)')
  call submode#map('emmet-n', 'i', 'r', 'n', '<Plug>(emmet-move-next)')
  call submode#map('emmet-n', 'i', 'r', 'N', '<Left><Plug>(emmet-move-prev)')
endfunction
