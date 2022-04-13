" echo message highlighted by ErrorMsg
function! my#error_msg(msg) abort
  echohl ErrorMsg | echo a:msg | echohl none
endfunction

" echo message highlighted by WarningMsg
function! my#warning_msg(msg) abort
  echohl WarningMsg | echo a:msg | echohl none
endfunction

" yank and echo
function! my#echo_and_yank(obj) abort
  call setreg(v:register, (type(a:obj) == v:t_float ? printf('%s', a:obj) : a:obj))
  echo a:obj
endfunction

function! my#snakecase(word) abort
  return go#util#snakecase(w)
endfunction

" total number in selected range
" 文字列を',', ' 'でsplitして分割し、それをstr2float or str2nrで変換して計算
let s:my_sum_cnt = 0
function! my#sum(is_float) abort
  let convert_func = a:is_float ? 'str2float' : 'str2nr'
  silent %s/\(\%V.*\%V.\)/\=execute('let s:my_sum_cnt += ' . join(map(split(submatch(0), '\(\s\|,\)\+'), convert_func . '(v:val)'), ' + '))/n
  call my#echo_and_yank(s:my_sum_cnt)
  let s:my_sum_cnt = 0
endfunction

" toggle transparency
function! my#toggle_transparency() abort
  if exists('&transparency')
    if &transparency == 255
      set transparency=205
    else
      set transparency=255
    endif
  else
    call my#error_msg('Not exists transparency option!')
  endif
endfunction

" change font size for review, resize the window after changing
function! my#toggle_fontsize() abort
  if &guifont =~# 'h9'
    set guifont=MS_Gothic:h12:cSHIFTJIS
  elseif &guifont =~# 'h12'
    set guifont=MS_Gothic:h16:cSHIFTJIS
  elseif &guifont =~# 'h16'
    set guifont=MS_Gothic:h20:cSHIFTJIS
  elseif &guifont =~# 'h20'
    set guifont=MS_Gothic:h24:cSHIFTJIS
  else
    set guifont=MS_Gothic:h9:cSHIFTJIS
  endif
  wincmd =
endfunction

" sleep specified milliseconds.
" REF: copied vim-operator-flashy.vim
function! my#sleep(ms) abort
  let t = reltime()
  while !getchar(1) && a:ms - str2float(reltimestr(reltime(t))) * 1000.0 > 0
  endwhile
endfunction

" get project root
" if check vital source, can make more tightly
function! my#get_root_dir(...) abort
  " 検索対象にvimも追加
  let target_dir = escape(get(a:000, 0, expand('%:p:h')) . ';', ' ')
  let search_dir_names = ['.svn', '.git', 'vim', 'vim80', 'vim81']

  for dir_name in search_dir_names
    let ret_dir = finddir(dir_name, target_dir)
    if !empty(ret_dir)
      " return substitute(fnamemodify(ret_dir, ':p:h'), '\(\\\|\/\)' . dir_name . '$', '', 'g')
      return fnamemodify(ret_dir, ':p:h:h')
    endif
  endfor

  " not found
  return ''
endfunction

" do ctags
function! my#do_ctags(do_all) abort
  if !has('win32')
    call my#error_msg('Not ready except windows..')
    return
  endif

  if isdirectory('.svn') || isdirectory('.git')
    if input('now: ' . getcwd() . "\nrun ctags? (y)es or (n)o : ") =~? '^y\%[es]$'
      if a:do_all
        silent !start ctags -R
      else
        silent !start ctags -R --exclude=test
      endif
    endif
  else
    call my#error_msg('Check current dir!')
  endif
endfunction

" build cscope
function! my#cscope_build() abort
  if !has('win32')
    call my#error_msg('Not ready except windows..')
    return
  endif

  if isdirectory('.svn') || isdirectory('.git')
    if input('now: ' . getcwd() . "\nRun cscope -Rb? (y)es or (n)o : ") =~# '^y$\|^yes$'
      silent !start cscope -Rb
    endif
  else
    call my#error_msg('Check current dir!')
  endif
endfunction

" add cscope
function! my#cscope_add() abort
  if (isdirectory('.svn') || isdirectory('.git')) && filereadable('cscope.out')
    cscope add cscope.out
    echo "cscope add cscope.out!"
  else
    call my#error_msg('Check current dir!')
  endif
endfunction

" flash only display lines in window
" REF: vim-operator-flashy
function! my#flash_window(ms, flash_hi_group) abort
  try
    let highlight_range = '\%>' . (line('w0') - 1) . 'l\_.*\%<' . (line('w$') + 1) . 'l'
    let match_range_id = matchadd(a:flash_hi_group, highlight_range, 100)
    let match_cursor_id = matchadd('Cursor', '\%#', 101)
    redraw

    call my#sleep(a:ms)
  finally
    if exists('match_range_id')
      call matchdelete(match_range_id)
    endif

    if exists('match_cursor_id')
      call matchdelete(match_cursor_id)
    endif
  endtry
endfunction

" convert decimal -> hex and yank
function! my#decimal2hex_and_yank(dec) abort
  let str = printf('0x%04x', a:dec)
  call my#echo_and_yank(str)
endfunction

" convert hex -> decimal and yank
function! my#hex2decimal_and_yank(hex) abort
  let str = printf('%d', type(a:hex) == v:t_number ? a:hex : str2nr(a:hex, 16))
  call my#echo_and_yank(str)
endfunction

" convert hex -> binary and yank
function! my#hex2binary_and_yank(hex) abort
  let str = printf('0b%08b', type(a:hex) == v:t_number ? a:hex : str2nr(a:hex, 16))
  call my#echo_and_yank(str)
endfunction

" convert decimal -> binary and yank
function! my#decimal2binary_and_yank(dec, ...) abort
  let n = get(a:000, 0, 8)
  let str = printf('0b%0' .  n . 'b', a:dec)
  call my#echo_and_yank(str)
endfunction

" flash search words
" NOTE: when specified offset for search, it not working eg. /hoge/1
" REF: that wrote someone's vimrc. forget..
function! my#flash_search_word(ms) abort
  try
    if &runtimepath !~# 'vim-anzu' || empty(anzu#search_status())
      return
    endif

    let match_last_en = matchstr(@/, '\\\+$')

    if empty(match_last_en) == 1
      let end = '\)'
    elseif len(match_last_en) % 2 == 0
      let end = '\)'
    else
      " 末尾が奇数個の\だった場合は\追加。で、さらに\(を追加
      let end = '\\)'
    endif

    " let match_pattern_id = matchadd('CursorIM', '\c\%#\(' . @/ . '\)' , 100)
    let match_pattern_id = matchadd('CursorIM', '\c\%#\(' . @/ . end, 100)
    let match_cursor_id = matchadd('Cursor', '\%#', 101)
    redraw

    call my#sleep(a:ms)
  finally
    if exists('match_pattern_id')
      call matchdelete(match_pattern_id)
    endif

    if exists('match_cursor_id')
      call matchdelete(match_cursor_id)
    endif
  endtry
endfunction

" Move to the midpoint with M when L or H pressed twice
" REF: haya14busa vimrc(もう消されてそうでした)
function! my#HL(motion, is_visual) abort
  let current_line = line('.')
  if &scrolloff == 0
    let flag_line =  a:motion ==# 'H' ? line('w0') : line('w$')
  else
    let flag_line =  a:motion ==# 'H' ? line('w0') + &scrolloff : line('w$') - &scrolloff
  endif

  if a:is_visual
    normal! gv
  endif
  if current_line == flag_line && v:count == 0
    let middle_line = (line('w$') - line('w0') + 1) / 4 + 1
    execute 'normal! ' . middle_line . a:motion
  else
    execute 'normal! ' . v:count . a:motion
  endif
endfunction

" Move to the first column of the line(similar to pressed 0) when underscore pressed twice
" TODO: expr使えばgv使わなくても楽にできそうとのこと
function! my#underscore(motion, is_visual) abort
  if a:is_visual
    normal! gv
  endif
  let current_pos = col(".")

  let flag_pos = searchpos('\%' . line('.') . 'l^\s\+\zs\S', 'nc')[1]

  if current_pos == flag_pos && v:count == 0
    normal! 0
  else
    execute 'normal! ' . v:count . a:motion
  endif
endfunction

function! my#gf() abort
  let target = expand('<cfile>')
  if target ==# ''
    call my#error_msg('Not found file path!')
    return
  endif

  " let not_vim_extension = ['xls', 'ptt']
  let not_vim_extension = ['ptt']
  if index(not_vim_extension, fnamemodify(target, ':e')) ==# -1
    vertical botright wincmd F
    normal! zz
  else
    execute '!start' shellescape(target)
  endif
endfunction

" clear register
function! my#clear_registers(ignore_chars) abort
  let clear_registers = my#s('abcdefghijklmnopqrstuvwxyz', join(split(a:ignore_chars, '\zs'), '\|'), '')
  for char in split(clear_registers, '\zs')
    execute 'let @' . char . ' = ""'
  endfor
endfunction

" delete between if0 and endif
" in case of exists if0, else, endif. delete lines except between else and endif
function! my#delete_if_zero() abort
  if expand('<cword>') ==# 'if'
  endif
  let poss = []
  " if0 - end,  if0 - else - endでも動作するように最小公倍数分だけ回す
  while 6 > len(poss)
    call add(poss, line('.'))
    normal! %
  endwhile
  call uniq(sort(poss, 'n'))
  if len(poss) != 3 && len(poss) != 2 && expand('<cword>') !=# 'if'
    call my#error_msg('Check cursor position!')
  endif

  if len(poss) == 3
    " if0 - else - endifの場合にはendifを削除
    silent execute poss[2] | delete
  endif
  silent execute poss[0] . ',' . poss[1] . 'delete'
else
  call my#error_msg('Check cursor position!')
endif
endfunction
" nnoremap <Leader>d0 :<C-u>call my#delete_if_zero()<CR>

" copy past memo
let s:ONE_DAY = 60 * 60 * 24
function! my#copy_or_open_past_file(dir_path, prefix_format, suffix, range_start, range_end, do_copy) abort
  if isdirectory(a:dir_path)
    let file_path = my#get_past_memo_file(a:dir_path, a:prefix_format, a:suffix, a:range_start, a:range_end)
    if !empty(file_path)
      execute 'split' file_path
      if a:do_copy
        execute 'saveas' (a:dir_path . '/' . strftime(a:prefix_format) . a:suffix)
      endif
    else
      call my#error_msg('Not found!')
    endif
  else
    call my#error_msg('Check dir path!')
  endif
endfunction

function! my#get_past_memo_file(dir_path, prefix_format, suffix, range_start, range_end) abort
  let lnum = a:range_start
  while lnum <= a:range_end
    let file_path = a:dir_path . '/' . strftime(a:prefix_format, localtime() - (s:ONE_DAY * lnum)) . a:suffix
    if filereadable(file_path)
      return file_path
    endif
    let lnum += 1
  endwhile
  return ''
endfunction

" REF: vital.vim s:get_last_selected()
" REF: https://github.com/vim-jp/vital.vim/commit/459a61a55cae9aad09258015f09fa45389fcce1e
function! my#selected_text() abort
  let save = getreg('"', 1)
  let save_type = getregtype('"')
  try
    normal! gv""y
    return @"
  finally
    call setreg('"', save, save_type)
  endtry
endfunction

" REF: http://d.hatena.ne.jp/osyo-manga/20130202/1359735271
" 上手く動いていない
function! my#back_slash_linefeed()
  call setline(line("."), my#add_back_slash(getline(line(".")), getline(line(".") - 1)))
  return ""
endfunction
function! my#add_back_slash(line, before_line)
  let prefix = my#s(a:before_line, '\(^\s*\).*', '\1', '')
  let s:prefix_count = len(prefix)
  if empty(a:line)
    return prefix . '\ '
  else
    let line = my#s(a:line, '^\s*', '', '')
    return prefix . '\ ' . line
  endif
endfunction

function! my#diff_settings() abort
  if &diff
    setlocal nocursorline
    nnoremap <silent><buffer> u         u:diffupdate<CR>
    nnoremap <silent><buffer> <C-r>     <C-r>:diffupdate<CR>
    nnoremap <silent><buffer> <Leader>> :<C-u>diffput<CR>
    nnoremap <silent><buffer> <Leader>< :<C-u>diffget<CR>
  endif
endfunction

function! my#s(expr, pat, sub, ...) abort
  return substitute(a:expr, a:pat, a:sub, get(a:000, 0, 'g'))
endfunction
