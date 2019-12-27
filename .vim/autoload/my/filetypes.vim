" REF: that wrote someone's vimrc. forget..
function! my#filetypes#setting(ftype) abort
  let ftype = my#s(a:ftype, '-', '_')
  if !empty(ftype) && exists('*' . 'my#filetypes#' . ftype)
    execute 'call my#filetypes#' . ftype . '()'
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

function! my#filetypes#css() abort
  call s:set_indent(4, 0)
endfunction

function! my#filetypes#html() abort
  call s:set_indent(4, 0)
endfunction

function! my#filetypes#markdown() abort
  " call asyncomplete#disable_for_buffer()
endfunction

function! my#filetypes#txt() abort
  " call asyncomplete#disable_for_buffer()
endfunction

function! my#filetypes#javascript() abort
  call s:set_indent(4, 0)
endfunction

function! my#filetypes#cpp() abort
  call s:set_indent(4, 0)
endfunction

function! my#filetypes#gitconfig() abort
  call s:set_indent(4, 1)
endfunction

function! my#filetypes#gitcommit() abort
  setlocal spell
endfunction

function! my#filetypes#help() abort
  " qで閉じる
  nnoremap <buffer> q ZZ
endfunction

function! my#filetypes#unite() abort
  call my#plug#unite_vimfiler#unite_mapping()
endfunction

function! my#filetypes#vimfiler() abort
  call my#plug#unite_vimfiler#vimfiler_mapping()
endfunction

function! my#filetypes#denite() abort
  nnoremap <buffer><expr> <CR> denite#do_map('do_action')
  nnoremap <buffer><expr> d denite#do_map('do_action', 'delete')
  nnoremap <buffer><expr> p denite#do_map('do_action', 'preview')
  nnoremap <buffer><expr> q denite#do_map('quit')
  nnoremap <buffer><expr> i denite#do_map('open_filter_buffer')
  nnoremap <buffer><expr> a denite#do_map('open_filter_buffer')
  nnoremap <buffer><expr> <Space> denite#do_map('toggle_select').'j'
endfunction

function! my#filetypes#denite_filter() abort
  inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-j> denite#do_map('do_action')

  imap     <silent><buffer> <Esc> <Plug>(denite_filter_quit)
endfunction

function! my#filetypes#godoc() abort
  " qで閉じる
  nnoremap <buffer> q ZZ

endfunction

" REF: http://thinca.hatenablog.com/entry/20130708/1373210009
function! my#filetypes#qf() abort
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

  " vim-qfedit入れて編集できるようになったので、
  " よく使っちゃう編集用コマンドをnopにする
  nnoremap <buffer> a <NOP>
  nnoremap <buffer> A <NOP>
  nnoremap <buffer> i <NOP>
  nnoremap <buffer> I <NOP>
  nnoremap <buffer> r <NOP>
  nnoremap <buffer> R <NOP>
  nnoremap <buffer> gR <NOP>
  nnoremap <buffer> x <NOP>

  noremap  <buffer> c <NOP>
  noremap  <buffer> C <NOP>
  noremap  <buffer> > <NOP>
  noremap  <buffer> < <NOP>
  noremap  <buffer> <C-x> <NOP>
  noremap  <buffer> <C-a> <NOP>
  noremap  <buffer> + <NOP>
  noremap  <buffer> - <NOP>

  " " vim-qfedit導入したので、一旦コメントアウト
  " " 不要な項目の削除、削除した項目のundo
  " nnoremap <silent><buffer> dd :call <SID>del_entry()<CR>
  " xnoremap <silent><buffer> d :call <SID>del_entry()<CR>
  "
  " " 削除した項目のundo
  " nnoremap <silent><buffer> u :<C-u>call <SID>undo_entry()<CR>
  "
  " if exists('*s:undo_entry')
  "   return
  " endif
  "
  " function! s:undo_entry() abort
  "   let history = get(w:, 'qf_history', [])
  "   if !empty(history)
  "     call setqflist(remove(history, -1), 'r')
  "   endif
  " endfunction
  "
  " function! s:del_entry() range abort
  "   echo a:firstline
  "   let qf = getqflist()
  "   let history = get(w:, 'qf_history', [])
  "   call add(history, copy(qf))
  "   let w:qf_history = history
  "   unlet! qf[a:firstline - 1 : a:lastline - 1]
  "   call setqflist(qf, 'r')
  "   execute a:firstline
  " endfunction
endfunction

function! my#filetypes#go() abort
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
  nnoremap <buffer> <Space><Space> :<C-u>call my#filetypes#go_comment_for_tour_of_go('\_.*\_^\s*\/\/\zs', 'n', '\%' . line('$') . 'l', 'n')<CR>
endfunction

function! my#filetypes#calendar() abort
  setlocal synmaxcol&
endfunction

function! my#filetypes#go_comment_for_tour_of_go(search1, search1_flgs, search2, search2_flgs) abort
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
