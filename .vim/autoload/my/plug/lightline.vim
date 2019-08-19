function! my#plug#lightline#init() abort
  let g:lightline = {
        \   'mode_map': {
        \     'n':      'N',
        \     'i':      'I',
        \     'R':      'R',
        \     'v':      'V',
        \     'V':      'V-L',
        \     'c':      'COMMAND',
        \     "\<C-v>": 'V-B',
        \     's':      'SELECT',
        \     'S':      'S-L',
        \     't':      'T',
        \     "\<C-s>": 'S-B',
        \     '?':      '      '
        \   },
        \   'inactive': {
        \     'left':  [['filename', 'modified']],
        \     'right': [[]]
        \   },
        \   'tabline':{
        \     'left':  [['tabs']],
        \     'right': [[]]
        \   },
        \   'component_function': {
        \     'modified': 'my#plug#lightline#modified',
        \     'readonly': 'my#plug#lightline#readonly',
        \     'filename': 'my#plug#lightline#filename',
        \     'fileformat': 'my#plug#lightline#fileformat',
        \     'filetype': 'my#plug#lightline#filetype',
        \     'fileencoding': 'my#plug#lightline#fileencoding',
        \   },
        \   'tab_component_function': {
        \     'filename': 'my#plug#lightline#tab_filename'
        \   }
        \ }

  if has('win32')
    " activeなウィンドウだけstatusline変えたいから
    " colorschemeはjellybeansではなく、PaperColoerを指定
    let g:lightline.colorscheme = 'PaperColor'
  else
    let g:lightline.colorscheme = '16color'
  endif
endfunction


" tablineにroot dir名を表示
let g:my#plug#lightline#tabline_root_dir = 1
function! my#plug#lightline#tab_filename(n) abort
  if g:my#plug#lightline#tabline_root_dir
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let _ = expand('#'.buflist[winnr - 1].':p')

    " サーバのファイルも調べるのやめる
    if _ ==# '' || _ =~# '^\\\\'
      return '[No Root]'
    endif

    let root =  my#get_root_dir(_)
    if empty(root)
      return '[No Root]'
    endif
    return fnamemodify(root, ':t')
  else
    let buflist = tabpagebuflist(a:n)
    let winnr = tabpagewinnr(a:n)
    let _ = expand('#'.buflist[winnr - 1].':t')
    return _ !=# '' ? _ : '[No Name]'
  endif
endfunction

function! my#plug#lightline#modified() abort
  return &filetype =~# 'help\|vimfiler' ? '' :
        \ &buftype ==# 'terminal' ? '' :
        \ &modified ? '+' : ''
endfunction

function! my#plug#lightline#readonly() abort
  return &ft !~? 'help\|vimfiler' && &readonly ? 'RO' : ''
endfunction

function! my#plug#lightline#filename() abort
  if &filetype ==# 'qf'
    let last_qflist = getqflist({'title': 0, 'nr': '$', 'id': 0})
    let qflist      = getqflist({'title': 0, 'nr': 0,   'id': 0})
    return 'QuickFix | [' . qflist.id . '/' . last_qflist.id .  '] '. qflist.title
  else
    return ('' !=# my#plug#lightline#readonly() ? my#plug#lightline#readonly() . ' ' : '') .
          \ (&filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
          \ &buftype ==# 'terminal' ? 'Terminal' :
          \ '' !=# expand('%:t') ? expand('%:t') : '[No Name]')
  endif
endfunction

function! my#plug#lightline#fileformat() abort
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! my#plug#lightline#filetype() abort
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! my#plug#lightline#fileencoding() abort
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction
