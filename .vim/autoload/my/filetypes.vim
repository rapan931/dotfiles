function! my#filetypes#setting(ftype) abort
  if !empty(a:ftype) && exists('*' . 'my#filetypes#' . a:ftype)
    execute 'call my#filetypes#' . a:ftype . '()'
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

function! my#filetypes#javascript() abort
  call s:set_indent(4, 1)
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

function! my#filetypes#unite_vimfiler_init() abort
  " =================================
  " = setting: (Plugin)unite.vim
  let g:unite_source_find_command = 'C:/Program Files/Git/usr/bin/find.exe'
  let g:unite_source_grep_command = $GOPATH . '/bin/jvgrep.exe'
  let g:unite_source_grep_default_opts = '-i --exclude ''\.(git|svn|hg|bzr)'''
  let g:unite_source_grep_recursive_opt = '-R'
  let g:unite_source_rec_async_command = ['files', '-A', '-a']

  " max number of yank history
  let g:neoyank#limit = 200

  " disable neomru validation(execute :NeoMRUReload when notice)
  " max number of neomru history
  let g:neomru#do_validate = 0
  let g:neomru#file_mru_limit = 1000

  " mru exclude server path(start '//' or '\\')
  call unite#custom#source('file_mru,neomru/file', 'ignore_pattern', '\~$\|\.\%(o\|exe\|dll\|bak\|sw[po]\)$\|\%(^\|/\)\.\%(git\|svn\)\%($\|/\)\|^\%(//\|\\\\\)')
  call unite#custom#source('directory_mru', 'ignore_pattern', '\%(^\|/\)\.\%(hg\|git\|bzr\|svn\)\%($\|/\)\|^\%(//\|\\\\\)')

  " neomru/file do project directory(file_mru is target all files)
  call unite#custom#source('neomru/file', 'matchers', ['matcher_project_files', 'matcher_default'])

  " start insert mode
  call unite#custom#profile('default', 'context', {'start_insert' : 1})

  " grepでもauto closeする
  call unite#custom#profile('source/grep', 'context', {'no-quit' : 1})

  " Unite bufferでフルパス表示は
  " call unite#custom#source('buffer', 'converters', ['converter_full_path', 'converter_word_abbr'])

  " Unite file/file_mruで編集中のファイルは表示しない
  " call unite#custom#source('file,file_mru', 'matchers', ['matcher_hide_current_file'])

  " " Unite menu
  " let g:unite_source_menu_menus = {}
  " let g:unite_source_menu_menus.m = {'description': 'all menu'}
  " let g:unite_source_menu_menus.m.map = function('my#unite_menu_map')
  " if has('win32')
  "   let g:unite_source_menu_menus.m.candidates = [
  "  \   ['vimrc',            $MYVIMRC],
  "  \   ['command prompt',   '!start cmd'],
  "  \   ['explorer',         '!start rundll32 url.dll,FileProtocolHandler .'],
  "  \   ['explorer pc',      '!start explorer /e,/root,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}'],
  "  \   ['control panel',    '!start control'],
  "  \ ]
  " endif

  " outer_grep, outer_grep_add actionを追加
  let s:outer_grep = { 'description' : 'do outer grep' }
  function! s:outer_grep.func(candidate) abort
    try
      let pattern = input(&grepprg . ' ', '', 'customlist,my#complete#ripgrep')
      if pattern != ""
        silent execute 'grep!' escape(pattern, '|') a:candidate.action__path
      else
        throw 'non-pattern'
      endif
    catch /^Vim:Interrupt$\|^non-pattern$/
      echo 'Cancel'
    endtry
  endfunction
  call unite#custom_action('directory,file', 'outer_grep', s:outer_grep)
  unlet s:outer_grep

  " outer_grep_add actionを追加
  let s:outer_grep_add = { 'description' : 'do outer grep, and add quickfix list)' }
  function! s:outer_grep_add.func(candidate) abort
    try
      let pattern = input(&grepprg . ' ', '', 'customlist,my#complete#ripgrep')
      if pattern != ""
        silent execute 'grepadd!' escape(pattern, '|') a:candidate.action__path
      else
        throw 'non-pattern'
      endif
    catch /^Vim:Interrupt$\|^non-pattern$/
      echo 'Cancel'
    endtry
  endfunction
  call unite#custom_action('directory,file', 'outer_grep_add', s:outer_grep_add)
  unlet s:outer_grep_add

  " terminal actionを追加
  let s:terminal = { 'description' : 'open terminal' }
  function! s:terminal.func(candidate) abort
    try
      echo "terminal"
    catch /^Vim:Interrupt$\|^non-pattern$/
      echo 'Cancel'
    endtry
  endfunction
  call unite#custom_action('directory', 'terminal', s:terminal)
  unlet s:terminal

  let s:tortoise_svn_log = { 'description' : 'do TortoiseProc.exe log' }
  function! s:tortoise_svn_log.func(candidate) abort
    silent execute '!start TortoiseProc.exe /command:log /path:"' . a:candidate.action__path . '" /strict'
  endfunction
  call unite#custom_action('directory,file', 'tortoise_svn_log', s:tortoise_svn_log)
  unlet s:tortoise_svn_log

  " =================================
  " = setting: (Plugin)vimfiler.vim

  " 全部表示(default:['^\.'])
  " vimfilerをデフォルトのファイラーに設定
  let g:vimfiler_ignore_pattern = ''
  let g:vimfiler_as_default_explorer = 1

  call vimfiler#custom#profile('default', 'context', {
  \   'columns' : 'type'
  \ })
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
  nnoremap <silent><buffer><expr> <Leader>tl        unite#do_action('tortoise_svn_log')

  " <Leader><Leader>fでfile action
  nnoremap <silent><buffer><expr> <Leader><Leader>f unite#do_action('file')
endfunction

function! my#filetypes#vimfiler() abort

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

  if executable('golsp')
    setlocal omnifunc=lsp#complete
    nmap gd <plug>(lsp-definition)
  endif
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

  function! s:undo_entry() abort
    let history = get(w:, 'qf_history', [])
    if !empty(history)
      call setqflist(remove(history, -1), 'r')
    endif
  endfunction

  function! s:del_entry() range abort
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
