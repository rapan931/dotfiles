function! my#plug#unite_vimfiler#init() abort
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

  " outer grep
  let s:untie_action = { 'description' : 'outer grep' }
  function! s:untie_action.func(candidates) abort
    try
      let pattern = input(&grepprg . ' ', '', 'customlist,my#complete#ripgrep')
      if pattern != ""
        silent execute 'grep!' escape(pattern, '|') a:candidates.action__path
      else
        throw 'non-pattern'
      endif
    catch /^Vim:Interrupt$\|^non-pattern$/
      echo 'Cancel'
    endtry
  endfunction
  call unite#custom_action('directory,file', 'outer_grep', s:untie_action)
  unlet s:untie_action

  " outer grep (Quickfixへの追加)
  let s:untie_action = { 'description' : 'outer grep, and add quickfix list)' }
  function! s:untie_action.func(candidates) abort
    try
      let pattern = input(&grepprg . ' ', '', 'customlist,my#complete#ripgrep')
      if pattern != ""
        silent execute 'grepadd!' escape(pattern, '|') a:candidates.action__path
      else
        throw 'non-pattern'
      endif
    catch /^Vim:Interrupt$\|^non-pattern$/
      echo 'Cancel'
    endtry
  endfunction
  call unite#custom_action('directory,file', 'outer_grep_add', s:untie_action)
  unlet s:untie_action

  " open terminal
  let s:untie_action = { 'description' : 'open terminal' }
  function! s:untie_action.func(candidates) abort
    let path = fnamemodify(a:candidates.action__path, ':p:h')
    execute 'topleft terminal ++close cmd /k cd /d ' . path . ' & set LANG=ja_JP.UTF-8'
  endfunction
  call unite#custom_action('directory,file', 'open_terminal', s:untie_action)
  unlet s:untie_action

  " open terminal(choose windows)
  let s:untie_action = { 'description' : 'open terminal(choose window)' }
  function! s:untie_action.func(candidates) abort
    call unite#take_action('choose', a:candidates)
    let path = fnamemodify(a:candidates.action__path, ':p:h')
    execute 'terminal ++curwin ++close cmd /k cd /d ' . path . ' & set LANG=ja_JP.UTF-8'
  endfunction
  call unite#custom_action('directory,file', 'open_terminal_choose_window', s:untie_action)
  unlet s:untie_action

  " TortoiseSVN log
  let s:untie_action = { 'description' : 'TortoiseProc.exe log' }
  function! s:untie_action.func(candidates) abort
    silent execute '!start TortoiseProc.exe /command:log /path:"' . a:candidates.action__path . '" /strict'
  endfunction
  call unite#custom_action('directory,file', 'tortoise_svn_log', s:untie_action)
  unlet s:untie_action

  " TortoiseSVN commit branch
  let s:untie_action = { 'description' : 'TortoiseProc.exe commit branch' }
  function! s:untie_action.func(candidates) abort
    if empty(my#get_root_dir(a:candidates.action__path))
      call my#error_msg('check dir!')
      return
    endif
    silent execute '!start TortoiseProc.exe /command:commit /path:"' . my#get_root_dir(a:candidates.action__path) . '" /strict'
  endfunction
  call unite#custom_action('directory,file', 'tortoise_svn_commit_branch', s:untie_action)
  unlet s:untie_action

  " yank root relative path
  " SEE: autoload/unite/kinds/common.vim(function! s:kind.action_table.yank.func(candidates))
  let s:untie_action = {'description' : 'yank root relative path', 'is_selectable' : 1, 'is_quit' : 0 }
  function! s:untie_action.func(candidates) abort
    let text = join(map(copy(a:candidates),
          \  {k, v -> my#get_root_dir(get(v, 'action__text', v.word)) ==# '' ?
          \    get(v, 'action__text', v.word) :
          \    my#s(get(v, 'action__text', v.word), my#s(my#get_root_dir(get(v, 'action__text', v.word)), '\', '/') . '/', '')}
          \ ), "\n")

    let @" = text

    echo 'Yanked:'
    echo text

    call setreg(v:register, text)
  endfunction
  call unite#custom_action('common', 'yank_root_relative_path', s:untie_action)
  unlet s:untie_action

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

function! my#plug#unite_vimfiler#unite_mapping() abort
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
  nnoremap <silent><buffer><expr> <Leader>tl        unite#do_action('tortoise_svn_log')
  nnoremap <silent><buffer><expr> <C-y>             unite#do_action('yank_root_relative_path')
  nnoremap <silent><buffer><expr> <Leader><Leader>c unite#do_action('tortoise_svn_commit_branch')

  " <Leader><Leader>fでfile action
  nnoremap <silent><buffer><expr> <Leader><Leader>f unite#do_action('file')
endfunction

function! my#plug#unite_vimfiler#vimfiler_mapping() abort
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
  nnoremap <silent><buffer><expr> <Leader><Leader>c vimfiler#do_action('tortoise_svn_commit_branch')

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
