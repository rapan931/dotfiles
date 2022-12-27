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

function! my#filetype#java() abort
  call s:set_indent(4, 1)

  " 末尾にセミコロンを入力して次の行に移る
  inoremap <buffer> <C-CR> <End>;<CR>
  inoremap <buffer> jk <End>;
endfunction

function! my#filetype#ruby() abort
  if expand('%:t') =~# '.*spec.rb$'
    nnoremap <buffer> <Leader>R :QuickRun rspec
  endif

  " 1行下に移動して改行
  " ポップアップ出てても動くように<C-e>入れとく。
  inoremap <buffer><expr> <C-CR> pumvisible() ? '<C-e><Down><End><CR>' : '<Down><End><CR>'

  inoremap <buffer> aaa assert_equal
endfunction

function! my#filetype#quickrun() abort
  " qで閉じる
  nnoremap <buffer> q :<C-u>q!<CR>
endfunction

function! my#filetype#xxd() abort
  setlocal binary
  %!xxd -g 4
endfunction

function! my#filetype#css() abort
  call s:set_indent(2, 0)

  " 末尾にセミコロンを入力して次の行に移る
  inoremap <buffer> <C-CR> <C-e>;<CR>
endfunction

function! my#filetype#vim() abort
  " 明示的に \ を付けて改行する
  imap <buffer> <C-CR> <Plug>(my-back-slash-linefeed)
endfunction

function! my#filetype#python() abort
  call s:set_indent(4, 0)
endfunction

function! my#filetype#html() abort
  call s:set_indent(2, 0)
  " call s:emmet_mapping()
endfunction

function! my#filetype#markdown() abort
endfunction

function! my#filetype#txt() abort
endfunction

function! my#filetype#typescript() abort
  call my#filetype#javascript()

  " 1行下に移動して改行
  " ポップアップ出てても動くように<C-e>入れとく。
  inoremap <buffer><expr> <C-CR> pumvisible() ? '<C-e><Down><End><CR>' : '<Down><End><CR>'
endfunction

function! my#filetype#typescriptreact() abort
  call my#filetype#javascript()
endfunction

function! my#filetype#javascript() abort
  " call s:set_indent(2, 0)
  " 末尾にセミコロンを入力して次の行に移る
  " inoremap <buffer> <C-CR> <End>;<CR>
  " inoremap <buffer> jk <End>;
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
  " 横幅のsyntaxハイライトが聞くようにする
  setlocal synmaxcol=0

  " insertモードでのペースト, カーソル移動
  inoremap <buffer> <C-y> <C-r>+
  inoremap <buffer> <C-b> <Left>
  inoremap <buffer> <C-f> <Right>

  " 画面最下部、最上部でのキー移動は普通のj,kのように(ループしないで)動いてほしい
  nmap <silent><buffer> j j
  nmap <silent><buffer> k k

  " <Leader><Leader>t, <Leader><Leader>Tでterminal open
  " <Leader><Leader>v, <Leader><Leader>sで分割してオープン
  " <Leader><Leader>g, <Leader><Leader>pで外部Grep
  " <C-y>でrootからの相対パスのyank
  nnoremap <silent><buffer><expr> <Leader><Leader>t unite#do_action('open_terminal')
  nnoremap <silent><buffer><expr> <Leader><Leader>T unite#do_action('open_terminal_choose_window')
  nnoremap <silent><buffer><expr> <Leader><Leader>v unite#do_action('right')
  nnoremap <silent><buffer><expr> <Leader><Leader>s unite#do_action('above')
  nnoremap <silent><buffer><expr> <Leader><Leader>g unite#do_action('outer_grep')
  nnoremap <silent><buffer><expr> <Leader><Leader>G unite#do_action('outer_grep_add')
  nnoremap <silent><buffer><expr> <C-y>             unite#do_action('yank_root_relative_path')

  " <Leader><Leader>fでfile action
  nnoremap <silent><buffer><expr> <Leader><Leader>f unite#do_action('file')
endfunction

function! my#filetype#vimfiler() abort
  " 横幅のsyntaxハイライトが効くようにする
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
  nnoremap <silent><buffer><expr> <Leader><Leader>t vimfiler#do_action('open_terminal')
  nnoremap <silent><buffer><expr> <Leader><Leader>T vimfiler#do_action('open_terminal_choose_window')
  nnoremap <silent><buffer><expr> <Leader><Leader>v vimfiler#do_action('right')
  nnoremap <silent><buffer><expr> <Leader><Leader>s vimfiler#do_action('above')
  nnoremap <silent><buffer><expr> <Leader><Leader>g vimfiler#do_action('outer_grep')
  nnoremap <silent><buffer><expr> <Leader><Leader>a vimfiler#do_action('outer_grep_add')
  nnoremap <silent><buffer><expr> <C-y>             vimfiler#do_action('yank_root_relative_path')
endfunction

function! my#filetype#fern() abort
  nmap <buffer><expr> <Plug>(fern-my-open-or-enter)
        \ fern#smart#leaf("<Plug>(fern-action-open:select)", "<Plug>(fern-action-enter)")

  " nmap <silent><buffer> h
  " nmap <silent><buffer> <CR> <Plug>(fern-action-open:select)
  nmap <silent><buffer> <CR> <Plug>(fern-my-open-or-enter)
  nmap <silent><buffer> l    <Plug>(fern-action-expand)
  nmap <silent><buffer> h    <Plug>(fern-action-collapse)
  " nmap <buffer><nowait> x <Plug>(fern-action-open:system)
  " nmap ..... <Plug>(fern-action-terminal:select)

  " " もう1つ上の階層に移動
  nmap <silent><buffer> - <Plug>(fern-action-leave)
endfunction

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
