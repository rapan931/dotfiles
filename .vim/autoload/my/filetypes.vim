function! my#filetypes#setting(ftype) abort
  if !empty(a:ftype) && exists('*' . 'my#filetypes#' . a:ftype)
    execute 'call my#filetypes#' . a:ftype . '()'
  else
    call s:set_indent(2, 0)
  endif
endfunction

function! s:set_indent(tab_length, is_hard_tab)
  if a:is_hard_tab
    setlocal noexpandtab
  else
    setlocal expandtab
  endif

  let &shiftwidth  = a:tab_length
  let &softtabstop = a:tab_length
  let &tabstop     = a:tab_length
endfunction

function! my#filetypes#javascript() abort
  call s:set_indent(4, 1)
endfunction

function! my#filetypes#cpp() abort
  call s:set_indent(4, 0)
endfunction

function! my#filetypes#gitconfig() abort
  call s:set_indent(4, 1)
endfunction

function! my#filetypes#help() abort
  " qで閉じる
  nnoremap <buffer> q ZZ
endfunction

function! my#filetypes#unite() abort
  " 横幅のsyntaxハイライトが聞くようにする
  setlocal synmaxcol=0

  " insertモードでのペースト, カーソル移動
  inoremap <buffer> <C-y> <C-r>+
  inoremap <buffer> <C-b> <Left>
  inoremap <buffer> <C-f> <Right>

  " 画面最下部、最上部でのキー移動は普通のj,kのように(ループしないで)動いてほしい
  nmap <silent><buffer> j j
  nmap <silent><buffer> k k

  " <Leader><Leader>tでtabopen action
  " <Leader><Leader>v, <Leader><Leader>sで分割してオープン
  " <Leader><Leader>g, <Leader><Leader>pで外部Grep
  nnoremap <silent><buffer><expr> <Leader><Leader>t unite#do_action('tabopen')
  nnoremap <silent><buffer><expr> <Leader><Leader>v unite#do_action('right')
  nnoremap <silent><buffer><expr> <Leader><Leader>s unite#do_action('above')
  nnoremap <silent><buffer><expr> <Leader><Leader>g unite#do_action('outer_grep')
  nnoremap <silent><buffer><expr> <Leader><Leader>G unite#do_action('outer_grep_add')

  " <Leader><Leader>fでfile action
  nnoremap <silent><buffer><expr> <Leader><Leader>f unite#do_action('file')
endfunction

function! my#filetypes#vimfiler() abort

  " 横幅のsyntaxハイライトが効くようにする(columns=''に設定しているから意味ないけど)
  setlocal synmaxcol=0

  " copyとpasteよく使うので使いやすいやつにリマップ
  " moveとc(宛先をinput()で入力してのコピー)はあんまり使わないのでつぶす
  nunmap <buffer> Cc
  nunmap <buffer> Cp
  nunmap <buffer> Cm
  nunmap <buffer> c
  nmap <buffer> C <Plug>(vimfiler_clipboard_copy_file)
  nmap <buffer> P <Plug>(vimfiler_clipboard_paste)

  " lにexpand_treeを割り当てる(ファイルを開かないようにする)
  nmap <buffer> l <Plug>(vimfiler_expand_tree)

  " 画面最下部、最上部でのキー移動は普通のj,kのように(ループしないで)動いてほしい
  nmap <silent><buffer> j j
  nmap <silent><buffer> k k

  " previewはpで実行。Vim標準のvはたまに使うのでunmap
  nmap <buffer> p <Plug>(vimfiler_preview_file)
  nmap <silent><buffer> v v

  " <Leader><Leader>tでタブオープン
  " <Leader><Leader>v, <Leader><Leader>sで分割してオープン
  " <Leader><Leader>gで外部Grep
  nnoremap <silent><buffer><expr> <Leader><Leader>t vimfiler#do_action('tabopen')
  nnoremap <silent><buffer><expr> <Leader><Leader>v vimfiler#do_action('right')
  nnoremap <silent><buffer><expr> <Leader><Leader>s vimfiler#do_action('above')
  nnoremap <silent><buffer><expr> <Leader><Leader>g vimfiler#do_action('outer_grep')
  nnoremap <silent><buffer><expr> <Leader><Leader>a vimfiler#do_action('outer_grep_add')

  " gcでカレントディレクトリを移動後にディレクトリ名を表示
  " nmap <buffer> gc <Plug>(vimfiler_cd_vim_current_dir):<C-u>pwd<CR>
  nmap <buffer> gc <Plug>(vimfiler_cd):<C-u>pwd<CR>

  " カーソル移動時にファイル/ディレクトリのパスを表示
  " http://secret-garden.hatenablog.com/entry/2016/08/04/000000
  " augroup my_filetype_vimfiler_group
  "     autocmd! * <buffer>
  "     autocmd CursorMoved <buffer> execute "normal \<Plug>(vimfiler_print_filename)"
  " augroup END
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

  " <CR>は普通のCRに戻す
  nnoremap <buffer> <CR> <CR>

  " pでプレビューっぽく動作、C-j/C-Kでプレビューっぽく動作した後カーソル移動
  nnoremap <buffer> p <CR>zz<C-w>p
  nnoremap <buffer> <C-k> k<CR>zrzz<C-w>p
  nnoremap <buffer> <C-j> j<CR>zrzz<C-w>p

  " 不要な項目の削除、削除した項目のundo
  nnoremap <silent><buffer> dd :call <SID>del_entry()<CR>
  xnoremap <silent><buffer> d :call <SID>del_entry()<CR>

  " 削除した項目のundo
  nnoremap <silent><buffer> u :<C-u>call <SID>undo_entry()<CR>

  if exists('*s:undo_entry')
    return
  endif

  function! s:undo_entry()
    let history = get(w:, 'qf_history', [])
    if !empty(history)
      call setqflist(remove(history, -1), 'r')
    endif
  endfunction

  function! s:del_entry() range
    echo a:firstline
    let qf = getqflist()
    let history = get(w:, 'qf_history', [])
    call add(history, copy(qf))
    let w:qf_history = history
    unlet! qf[a:firstline - 1 : a:lastline - 1]
    call setqflist(qf, 'r')
    execute a:firstline
  endfunction
endfunction

function! my#filetypes#go() abort
  call s:set_indent(4, 1)

  nnoremap <buffer> <Leader><Leader>r :<C-u>!go build -o %:r.exe %<CR>
  nnoremap <buffer> <Leader><Leader>R :<C-u>!go build -o %:r.exe % && %:r.exe<CR>
  xnoremap <buffer> <Leader>R :<C-u>echo 'no map'<CR>

  " for Tour of Go
  nnoremap <buffer> <Space><Space> :<C-u>call my#filetypes#go_comment_for_tour_of_go('\_.*\_^\s*\/\/\zs', 'n', '\%' . line('$') . 'l', 'n')<CR>
endfunction

function! my#filetypes#go_comment_for_tour_of_go(search1, search1_flgs, search2, search2_flgs) abort
  if &runtimepath !~ 'caw.vim'
    my#error_msg('not found caw.vim!')
  endif

  let line1 = search(a:search1, a:search1_flgs)
  let line2 = search(a:search2, a:search2_flgs)

  if line1 == 0 || line2 == 0
    my#error_msg('not found specified strings!')
  endif

  execute line1 . 'y'

  call setpos("'<", [bufnr('%'), line1, 0, 0])
  call setpos("'>", [bufnr('%'), line2, 0, 0])
  call caw#keymapping_stub('x', 'hatpos', 'comment')

  execute 'normal!' "Go\<Esc>p\<C-a>"
endfunction
