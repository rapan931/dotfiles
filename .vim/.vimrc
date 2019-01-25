scriptencoding utf-8
let g:skip_defaults_vim = 1

" if filereadable($HOME . '/minimal.vimrc')
"   set noloadplugins
"   source $HOME/minimal.vimrc
"   finish
" endif

" =================================
" = setting: initialize
function! s:mkdir(dir_path) abort
  if !isdirectory(a:dir_path)
    echomsg 'mkdir! ' . a:dir_path
    call mkdir(a:dir_path, "p")
  endif
endfunction

if has('vim_starting')
  if exists('$VIMFILES')
    " REF: https://github.com/vim-jp/issues/issues/1189
    let &runtimepath = expand('$VIMFILES') . ',' . &runtimepath
  else
    if has('win32')
      let $VIMFILES = $HOME . '/vimfiles'
    else
      let $VIMFILES = $HOME . '/.vim'
    endif
  endif

  " @Shougo's ware use $XDG_CACHE_HOME, but Windows not exist $XDG_CACHE_HOME. It set up.
  if !exists('$XDG_CACHE_HOME')
    let $XDG_CACHE_HOME = $VIMFILES . '/.cache'
    call s:mkdir($XDG_CACHE_HOME)
  endif

  " delete unused 'vimfiles' from runtimepath
  " set runtimepath-=$VIM/vimfiles
  " set runtimepath-=$VIM/vimfiles/after

  " prepare dev go
  " set runtimepath+=$GOROOT\misc\vim

  set viminfo& viminfo+='1000
endif

" opening ruby file is very slow, so adjust the color of 'end'
let g:ruby_no_expensive = 1

" REF: https://github.com/rhysd/dotfiles/blob/master/vimrc
" REF: :h autocmd-define
augroup vimrc_augroup
  autocmd!
augroup END
command! -nargs=* MyAutoCmd autocmd vimrc_augroup <args>
command! -nargs=* MyAutoCmdFT autocmd vimrc_augroup FileType <args>

" do not load unnecessary plugin
let g:plugin_autodate_disable  = 1
let g:plugin_scrnmode_disable  = 1
let g:plugin_verifyenc_disable = 1
let g:plugin_hz_ja_disable     = 1
let g:plugin_dicwin_disable    = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_getscript         = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_2html_plugin      = 1

" do not register Autocmd related to file type
" let g:did_load_filetypes = 1

" do not load menu.vim
" NOTE: have to setting M option before 'syntax on'
set guioptions-=M

" also delete other guioptions and empty
" * hide toolbar
" * use non-GUI tab pages line
" * hide scroll bar
" * hide menu
" * disable tear off menu items
" * disable grey menu items
set guioptions-=T guioptions-=e
set guioptions-=r guioptions-=R guioptions-=l guioptions-=L
set guioptions-=m guioptions-=t guioptions-=g

" REF: dein.txt
function! s:sid() abort
  return matchstr(expand('<sfile>'), '\zs<SNR>\d\+_\zeSID$')
endfunction

" 先にimsearchを設定して、常にIMEオフ状態で/が始まるようにする(ダサいけど、echoつけてcmdlineきれいにする)
MyAutoCmd CmdlineLeave / call feedkeys(":set imsearch=0 | :echo\<CR>")

" =================================
" = Plugin install (by minpac)

set packpath=$VIMFILES
" packpack's path add rtp
" REF: https://github.com/vim-jp/issues/issues/1189

call s:mkdir(&packpath . '/pack/m/opt')
call s:mkdir(&packpath . '/pack/m/start')
packadd minpac
call minpac#init({'package_name': 'm', 'verbose': 3, 'depth': 0})

" minpac
call minpac#add('k-takata/minpac', {'type': 'opt'})

" unite
call minpac#add('Shougo/unite.vim', {'type': 'opt'})
call minpac#add('Shougo/neomru.vim')
call minpac#add('Shougo/neoyank.vim')
call minpac#add('Shougo/unite-outline')
call minpac#add('Shougo/vimfiler.vim', {'type': 'opt'})
call minpac#add('Shougo/vimproc')

" fzf
call minpac#add('junegunn/fzf.vim')
call minpac#add('junegunn/fzf')

" complete
" call minpac#add('Shougo/neocomplete.vim', {'type': 'opt'})
call minpac#add('Shougo/neosnippet.vim')
call minpac#add('Shougo/neosnippet-snippets')

" search
call minpac#add('easymotion/vim-easymotion')
call minpac#add('haya14busa/incsearch.vim')
call minpac#add('haya14busa/vim-asterisk')
call minpac#add('osyo-manga/vim-anzu')

" textobj
call minpac#add('kana/vim-textobj-user')
call minpac#add('kana/vim-textobj-line')
call minpac#add('kana/vim-textobj-indent')
call minpac#add('sgur/vim-textobj-parameter')
call minpac#add('thinca/vim-textobj-between')
call minpac#add('glts/vim-textobj-comment')
call minpac#add('osyo-manga/vim-textobj-multiblock')
call minpac#add('osyo-manga/vim-textobj-from_regexp')
call minpac#add('rhysd/vim-textobj-conflict')

" operator
call minpac#add('kana/vim-operator-user')
call minpac#add('kana/vim-operator-replace')
call minpac#add('haya14busa/vim-operator-flashy')
call minpac#add('machakann/vim-sandwich', {'type': 'opt'})

" colorscheme
call minpac#add('chriskempson/vim-tomorrow-theme')
call minpac#add('nanotech/jellybeans.vim')
" call minpac#add('danilo-augusto/vim-afterglow')

" go
call minpac#add('fatih/vim-go', {'type': 'opt'})

" markdown
call minpac#add('kannokanno/previm')
call minpac#add('Shougo/context_filetype.vim')
call minpac#add('osyo-manga/vim-precious')

" other
call minpac#add('itchyny/lightline.vim')
call minpac#add('junegunn/vim-easy-align')
call minpac#add('kana/vim-submode', {'type': 'opt'})
call minpac#add('osyo-manga/shabadou.vim')
call minpac#add('osyo-manga/vim-jplus')
call minpac#add('rhysd/clever-f.vim')
call minpac#add('syngan/vim-clurin')
call minpac#add('t9md/vim-choosewin')
call minpac#add('t9md/vim-quickhl')
call minpac#add('thinca/vim-quickrun')
call minpac#add('thinca/vim-zenspace')
call minpac#add('tyru/caw.vim')
call minpac#add('tyru/open-browser.vim')
call minpac#add('tyru/open-browser-github.vim')
call minpac#add('PProvost/vim-ps1')
call minpac#add('cohama/lexima.vim', {'type': 'opt'})
call minpac#add('kshenoy/vim-signature')
call minpac#add('t9md/vim-textmanip')
call minpac#add('glidenote/memolist.vim')
call minpac#add('haya14busa/vim-edgemotion')
call minpac#add('kana/vim-altr', {'type': 'opt'})
call minpac#add('vim-jp/autofmt')
call minpac#add('mopp/sky-color-clock.vim')
call minpac#add('rapan931/vim-pgpuzzle')
call minpac#add('rhysd/committia.vim')

" doc
call minpac#add('vim-jp/vimdoc-ja', {'type': 'opt'})

" view only
call minpac#add('vim-jp/vital.vim', {'type': 'opt'})

filetype plugin indent on
syntax enable

" init
" packadd neocomplete.vim
packadd vim-submode
packadd vim-altr
packadd unite.vim
packadd vimfiler.vim
packadd vimdoc-ja
packadd vim-go

" =================================
" = setting: fzf.vim

let g:fzf_layout = {'up': '~45%'}
" let g:fzf_colors = {"prompt":  ["fg", "Ignore"]}
let g:fzf_colors = {"prompt":  ["fg", "PreProc"]}
let $FZF_DEFAULT_OPTS = '--exact --layout=reverse --inline-info --margin=0,2 --no-bold'

" =================================
" = setting: (Plugin)unite.vim & vimfiler.vim

call my#filetypes#unite_vimfiler_init()

" =================================
" = setting: (Plugin)vim-precious & context_filetype.vim

" markdownでのみ機能するよう修正
let g:precious_enable_switchers = {'*': {'setfiletype': 0}, 'markdown': {'setfiletype': 1}}
let g:precious_enable_switch_CursorMoved   = {'*': 0, 'markdown': 1}
let g:precious_enable_switch_CursorMoved_i = {'*': 0, 'markdown': 1}

" =================================
" = setting: (Plugin)vim-altr

call altr#remove_all()

" vim
" go
" vim(opeartor-user and textobj-user based Vim plugins)
call altr#define('autoload/%.vim', 'doc/%.txt', 'plugin/%.vim')
call altr#define('%.go', '%_test.go')
call altr#define('autoload/%/%.vim', 'doc/%-%.txt', 'plugin/%/%.vim')

" =================================
" = setting: (Plugin)neocomplete.vim

" いつも使う
" smartcaseで楽々
" 自動補完無効
" vimproc使ってのキャッシュ作成無効
" let g:neocomplete#enable_at_startup = 1
" let g:neocomplete#enable_smart_case = 1
" let g:neocomplete#disable_auto_complete = 1
" let g:neocomplete#use_vimproc = 0

" =================================
" = setting: (Plugin)neosnippet.vim

let g:neosnippet#snippets_directory = $VIMFILES . '/snippet'
call s:mkdir(g:neosnippet#snippets_directory)
let g:neosnippet#scope_aliases = {'cpp': 'c'}

" =================================
" = setting: (Plugin)vim-go

" quickfixのみ使用
let g:go_list_type = "quickfix"

" =================================
" = setting: (Plugin)incsearch.vim

" errorメッセージをmessage-historyにsaveしない
let g:incsearch#do_not_save_error_message_history = 1

" 検索文字入力後の<CR>でanzuのステータス情報を表示
" -> feedkeys(":\<C-u>call anzu#echohl_search_status()\<CR>", 'n')だと
"    なぜか検索文字の後ろに\cがついてしまう??(しまう??)
" -> call anzu#echohl_search_status()だとanzuのステータス情報が出ない
MyAutoCmd User IncSearchExecute AnzuUpdateSearchStatus |
\ if anzu#search_status() != '' |
\   call feedkeys(":\<C-u>AnzuUpdateSearchStatusOutput\<CR>", 'n') |
\ endif

" =================================
" = setting: (Plugin)clever-f.vim

" プラグインのデフォルトキーマップを適用しない
" 複数行にまたがない
" 大文字小文字を区別
" smartcaseは使わない
" プロンプトに"clever-f:"と表示 -> (特に必要ないけど一瞬フラッシュするのがUX的にいい感じ)
let g:clever_f_not_overwrites_standard_mappings = 1
let g:clever_f_across_no_line = 1
let g:clever_f_ignore_case = 0
let g:clever_f_smart_case = 0
let g:clever_f_show_prompt = 1

" =================================
" = setting: (Plugin)vim-easymotion

" プラグインのデフォルトキーマップを適用しない
" easymotion用のキーもvimfilerに合わせる
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_keys = 'sdfghjkl;qwertyuiopzcvbnm'

" =================================
" = setting: (Plugin)vim-operator-flashy

" 点灯時間を300msに変更
" ハイライトグループを'MyFlashy'に変更
let g:operator#flashy#flash_time = 300
let g:operator#flashy#group = 'MyFlashy'

" =================================
" = setting: (Plugin)vim-signature

" markした行のハイライトグループを'Underlined'に設定
" marks/markersのpurge時に確認する
" default mappingを変更(使わなそうなの削除)
let g:SignatureMarkLineHL = 'Underlined'
let g:SignatureMarkerLineHL = 'Underlined'
let g:SignaturePurgeConfirmation = 1
let g:SignatureMap = {
\   'Leader':            "m",
\   'PlaceNextMark':     "",
\   'ToggleMarkAtLine':  "m.",
\   'PurgeMarksAtLine':  "",
\   'DeleteMark':        "",
\   'PurgeMarks':        "m<Space>",
\   'PurgeMarkers':      "",
\   'GotoNextLineAlpha': "",
\   'GotoPrevLineAlpha': "",
\   'GotoNextSpotAlpha': "",
\   'GotoPrevSpotAlpha': "",
\   'GotoNextLineByPos': "",
\   'GotoPrevLineByPos': "",
\   'GotoNextSpotByPos': "",
\   'GotoPrevSpotByPos': "",
\   'GotoNextMarker':    "",
\   'GotoPrevMarker':    "",
\   'GotoNextMarkerAny': "",
\   'GotoPrevMarkerAny': "",
\   'ListBufferMarks':   "m/",
\   'ListBufferMarkers': "m?"
\ }

" =================================
" = setting: (Plugin)vim-submode

" windowサイズの変更
call submode#enter_with('winsize', 'n', '', 'z>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', 'z<', '<C-w><')
call submode#enter_with('winsize', 'n', '', 'z+', '<C-w>+')
call submode#enter_with('winsize', 'n', '', 'z-', '<C-w>-')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>+')
call submode#map('winsize', 'n', '', '-', '<C-w>-')

" " quickfixのcnext, cprev
" call submode#enter_with('quickfix', 'n', '', '<Leader>qj', ':<C-u>cnext<CR>')
" call submode#enter_with('quickfix', 'n', '', '<Leader>qk', ':<C-u>cprevious<CR>')
" call submode#map('quickfix', 'n', '', 'j', ':<C-u>cnext<CR>')
" call submode#map('quickfix', 'n', '', 'k', ':<C-u>cprevious<CR>')

" 変更箇所への移動
" thinca's vimrc
call submode#enter_with('change-list', 'n', '', 'g;', 'g;')
call submode#enter_with('change-list', 'n', '', 'g,', 'g,')
call submode#map('change-list', 'n', '', ';', 'g;')
call submode#map('change-list', 'n', '', ',', 'g,')

" :tagの実行(<C-t>(:pop)の逆)
call submode#enter_with('tag', 'n', '', 'g<C-t>', ':<C-u>tag<CR>')
call submode#map('tag', 'n', '', 't', ':<C-u>tag<CR>')

" :colder, cnewerの実行(事前にbotright copen)
call submode#enter_with('cnew-colder', 'n', '', 'g<C-k>', ':<C-u>copen<CR>:<C-u>colder<CR>')
call submode#enter_with('cnew-colder', 'n', '', 'g<C-j>', ':<C-u>copen<CR>:<C-u>cnewer<CR>')
call submode#map('cnew-colder', 'n', '', '<C-k>', ':<C-u>colder<CR>')
call submode#map('cnew-colder', 'n', '', '<C-j>', ':<C-u>cnewer<CR>')

" " カーソル位置起点でのマークへのジャンプ
" call submode#enter_with('jump-mark', 'n', '', 'mj', "]'")
" call submode#enter_with('jump-mark', 'n', '', 'mk', "['")
" call submode#map('jump-mark', 'n', '', 'j', "]'")
" call submode#map('jump-mark', 'n', '', 'k', "['")

" =================================
" = setting: (Plugin)lightline.vim START{'normal': {}}

" activeなウィンドウだけstatusline変えたいから colorschemeはPaperColoerを指定
let g:lightline = {
\   'colorscheme': 'PaperColor',
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
\     'modified': 'LightlineModified',
\     'readonly': 'LightlineReadonly',
\     'filename': 'LightlineFilename',
\     'fileformat': 'LightlineFileformat',
\     'filetype': 'LightlineFiletype',
\     'fileencoding': 'LightlineFileencoding',
\   },
\ }

if !has('win32')
  let g:lightline.colorscheme = '16color'
endif

function! LightlineModified() abort
  return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : ''
endfunction

function! LightlineReadonly() abort
  return &ft !~? 'help\|vimfiler' && &readonly ? 'RO' : ''
endfunction

function! LightlineFilename() abort
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
  \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
  \ '' != expand('%:t') ? expand('%:t') : '[No Name]')
endfunction

function! LightlineFileformat() abort
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype() abort
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding() abort
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode() abort
  return winwidth(0) > 70 ? lightline#mode() : ''
endfunction

" =================================
" = setting: (Plugin)caw.vim start

" プラグインのデフォルトキーマップを適用しない
let g:caw_no_default_keymappings = 1

" =================================
" = setting: (Plugin)vim-easy-align

" cppコメント(//)の位置揃え
let g:easy_align_delimiters = {
\   '/': {'pattern': '//\+', 'delimiter_align': 'l', 'ignore_groups': ['!Comment']}
\ }

" =================================
" = setting: (Plugin)vim-clurin

function! ClurinCtrlAX(cnt) abort
  if a:cnt >= 0
    execute 'normal!' a:cnt . "\<C-A>"
  else
    execute 'normal!' (-a:cnt) . "\<C-X>"
  endif
endfunction

let g:clurin = {
\   '-': {
\     'def': [
\       ['on', 'off'],
\       ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
\       ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'],
\       ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
\       ['True', 'False'],
\       ['true', 'false'],
\       ['TRUE', 'FALSE'],
\       ['Yes', 'No'],
\       ['ok', 'ng'],
\       ['Ok', 'Ng'],
\       ['OK', 'NG'],
\       ['ON', 'OFF'],
\       ['enable', 'disable'],
\       ['Enable', 'Disable'],
\       ['ENABLE', 'DISABLE'],
\       ['有効', '無効'],
\       ['有り', '無し'],
\       ['作成', '削除'],
\       ['未着手', '着手', '完了'],
\       ['&&', '||'],
\       ['==', '!='],
\       ['■', '□'],
\       ['×', '○'],
\       ['月' ,'火' ,'水' ,'木' ,'金' ,'土' ,'日'],
\       [
\         '①' ,'②' ,'③' ,'④' ,'⑤' ,'⑥' ,'⑦' ,'⑧' ,'⑨' ,'⑩' ,
\         '⑪' ,'⑫' ,'⑬' ,'⑭' ,'⑮' ,'⑯' ,'⑰' ,'⑱' ,'⑲' ,'⑳'
\       ],
\     ],
\     'nomatch': function('ClurinCtrlAX'),
\   },
\   'use_default': 0,
\ }

" =================================
" = setting: (Plugin)vim-anzu

" echoに表示されるメッセージに末尾から先頭or先頭から末尾への移動時のメッセージを追加
let g:anzu_status_format = "%p(%i/%l) %#ErrorMsg#%w"

MyAutoCmd CmdlineLeave / if !empty(getcmdline()) |
\   call feedkeys(":AnzuUpdateSearchStatus | if anzu#search_status() != '' | AnzuUpdateSearchStatusOutput | endif\<CR>", 'n') |
\ endif

" =================================
" = setting: (Plugin)vim-textobj-xxxxx

" デフォルトのキーマッピングを使わない
let g:textobj_indent_no_default_key_mappings     = 1
let g:textobj_multiblock_no_default_key_mappings = 1
let g:textobj_parameter_no_default_key_mappings  = 1
let g:textobj_wiw_no_default_key_mappings        = 1
let g:textobj_precious_no_default_key_mappings   = 1
let g:textobj_conflict_no_default_key_mappings   = 1

" =================================
" = setting: (Plugin)vim-choosewin

" 選択先Windowで使用する文字順(vimfilerっぽく。(unite.vim/autoload/unite/init.vim))
" vimfilerっぽくsdfgh...で移動したいので、リマップ。xは危険な匂いがするからNOP
" フラッシュしない
" paddingを5に設定
let g:choosewin_label = 'sdfghjkl;qwertyuiopzcvbnm'
let g:choosewin_keymap = {"\<C-s>": 'swap', "\<C-t>": 'swap_stay', 'x': "\<NOP>"}
let g:choosewin_blink_on_land = 0
let g:choosewin_label_padding = 5

" =================================
" = setting: (Plugin)vim-quickrun

let g:quickrun_no_default_key_mappings = 1
let g:quickrun_config = {
\   '_': {
\     "hook/close_quickfix/enable_hook_loaded": 1,
\     "hook/close_quickfix/enable_success":     1,
\     "hook/close_buffer/enable_failure":       1,
\     "hook/close_buffer/enable_empty_data":    1,
\     "hook/inu/enable":                        1,
\     "hook/inu/wait":                          20,
\     "outputter":                              "multi:buffer:quickfix",
\     "outputter/buffer/split":                 ":botright 8",
\     "runner":                                 "job",
\   },
\ }

" =================================
" = setting: (Plugin)lexima.vim

" " Escキーのマップを除去
let g:lexima_map_escape = ''

packadd lexima.vim

" 初期化
call lexima#set_default_rules()

" ', '後の<CR>で末尾の空白を除去するよう設定
" REF: http://rhysd.hatenablog.com/entry/20121017/1350444269
call lexima#add_rule({ "char" : '<CR>', "at" : ', \%#', "input" : '<BS><CR>'})

" [ \%# ]の状態から']'の入力でleaveするようにする
call lexima#add_rule({'char': ']', 'at': '\[ \%# ]', 'leave': 2})

" <>の補完, 他と合わせ、'\'が直前にある場合にはinput_afterは行わない
call lexima#add_rule({'char': '<', 'input_after': '>', 'filetype': 'html'})
call lexima#add_rule({'char': '<', 'at': '\\\%#', 'filetype': 'html'})
call lexima#add_rule({'char': '>', 'at': '\%#>', 'leave': 1, 'filetype': 'html'})

" String,  Commentでは"{}"の補完を無効に
call lexima#add_rule({'char': '{', 'input': '{', 'syntax': 'String'})
call lexima#add_rule({'char': '{', 'input': '{', 'syntax': 'Comment'})

" call lexima#add_rule({'char': '<CR>', 'at': '```\s(\w\|\.)\+\%#```', 'input_after': '<CR>'})
" call lexima#add_rule({'char': '<CR>', 'at': '```\%#$', 'input_after': '<CR>```', 'except': '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s.+)\n)*\1```'})

" =================================
" = setting: (Plugin)memolist.vim

" memoファイルの補完場所
" ファイル保存時の拡張子
" uniteの設定
" let g:memolist_path = expand('$VIM') . '\.vim\memo'
let g:memolist_path = $VIMFILES . '/memo'
let g:memolist_memo_date = '%Y-%m-%d %H:%M:%S'
let g:memolist_memo_suffix = "md"
let g:memolist_unite = 1
let g:memolist_unite_option = "-start-insert"
let g:memolist_unite_source = "file"

" =================================
" = setting: (Plugin)vim-sandwich

let g:sandwich_no_default_key_mappings = 1
let g:operator_sandwich_no_default_key_mappings = 1

packadd vim-sandwich

call operator#sandwich#set_default()
call textobj#sandwich#set_default()

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
call extend(g:sandwich#recipes, [], 0)

call operator#sandwich#set('add', 'all', 'highlight', 10)
call operator#sandwich#set('delete', 'all', 'highlight', 10)
call operator#sandwich#set('add', 'all', 'hi_duration', 10)
call operator#sandwich#set('delete', 'all', 'hi_duration', 10)

" =================================
" = setting: (Plugin)previm

let g:previm_enable_realtime = 1

" =================================
" = setting: (Plugin)vim-pgpuzzle

let g:pgpuzzle_auto_load = 1

" =================================
" = setting: (Plugin)vim-pgpuzzle

let g:committia_use_singlecolumn = 'always'

" =================================
" = setting: (Plugin)open-browser.vim

" open by Chrome.
let g:openbrowser_browser_commands = [
\   {
\     'name': 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe',
\     'args': ['{browser}', '{uri}']
\   }
\ ]

" =================================
" = setting: Vim

if !has('win32')
  " REF: https://qiita.com/usamik26/items/f733add9ca910f6c5784
  let &t_ti.="\e[1 q"
  let &t_SI.="\e[5 q"
  let &t_EI.="\e[1 q"
  let &t_te.="\e[0 q"
endif

" 検索結果の強調
" 検索時に大文字小文字を無視
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
" インクリメンタル検索
" 検索時にファイルの最後まで行ったら最初に戻る
set hlsearch
set ignorecase
set smartcase
set incsearch
set wrapscan

" (見た目上の)折り返しをする
set wrap

" カーソル行ハイライト
set cursorline

" f : "(file 3 of 5)" の代わりに "(3 of 5)" を表示。
" i : "[最終行が不完全]" の代わりに "[noeol]" を表示。
" l : "999 行, 888 文字" の代わりに "999L, 888C" を表示。
" m : "[変更あり]" の代わりに "[+]" を表示。
" n : "[新ファイル]" の代わりに "[新]" を表示。
" r : "[読込専用]" の代わりに "[読専]" を表示。
" w : 書き込みコマンドには "書込み" の代わりに "[w]" を、コマンド
" s : "下まで検索したので上に戻ります" と "上まで検索したので下に戻ります" というメッセージを表示しない。
" x : "[dosフォーマット]" の代わりに "[dos]"とか
" t : ファイル間連のメッセージが長すぎてコマンドラインに収まらないときは、先頭を切り詰める。など
" T : その他のメッセージが長すぎてコマンドラインに収まらないときは、中央を切り詰める。など
" o : ファイルの書き込み時のメッセージを、その後のファイルの読み込み時のメッセージで上書きする
" O : ファイルの読み込み時のメッセージや Quickfix 関係のメッセージ(例えば ":cn") がその前のメッセージを必ず上書きする。
" I : Vimの開始時に挨拶メッセージを表示しない。
"
" (デフォルト: filnxtToO)
set shortmess=filmnrwsxtToOI

" ファイル名の表示
" 常にステータス行を表示
" コマンドラインの高さ
" コマンドをステータス行に表示
set title
set laststatus=2
set cmdheight=2
set showcmd

" 行番号の表示(落ち着くから)
" ルーラーを表示
" 長い行を折り返して表示
set number
set ruler
set wrap

" コマンドライン補完するときに強化されたものを使う
set wildmenu

" ウィンドウサイズを自動変更しない
" 水平分割の新規ウィンドウは右に作成する(垂直分割の設定は特にいじらない)
set noequalalways
set splitright

" タブの可視化
set list
set listchars=tab:^\ 

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
" REF: kaoriya同梱のvimrc
set formatexpr=autofmt#japanese#formatexpr()

" ウィンドウの最終行を頑張って表示
" なんか逆にもっさりする気がするからコメントアウト(もっさり?)
" set display=lastline

" syntaxが効く範囲を狭める(デフォルト3000)
set synmaxcol=200

" 横移動の幅を3に変更
set sidescroll=3

" カーソルキーで行末／行頭の移動可能に設定
set whichwrap=b,s,[,],<,>

" マッチするブロックに<>を追加
" かっこを入力した際にカーソルが移動しないようにする
set matchpairs& matchpairs+=<:>
set noshowmatch

" インクリメントするときに数値を10進で扱うように設定
set nrformats& nrformats-=octal

" copy indent from current line when starting a new line
" disable automatic C program indenting
" in insert mode: use the appropriate number of spaces to insert a <Tab>
" number of spaces that a <Tab> in the file counts for.
" number of spaces that a <Tab> counts for while performing editing operations, like inserting <Tab> or using <BS>
" number of spaces to use for each step (auto)indent
" inserting text width is infinite
" round indent to multiple of shiftwidth
set autoindent
set nocindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set textwidth=0
set shiftround

" exclude japanese from spell check
" ignore letter case
set spelllang+=cjk
set spellcapcheck=

" delete indent and line break in backspace
set backspace=indent,eol,start

" enable clipboard
set clipboard=unnamed

" no insert two spaces after a '.', '?' and '!' with a join command
" NOTE: vim-jplus ignore joinspaces option
set nojoinspaces

" Also break at a multi-byte character(mM)
" When joining lines, don't insert a space between two multi-byte characters(B)
" set formatoptions& formatoptions+=mBj
set formatoptions=tcroqmMj

" <EOF> at the end of file will be no restored if missing
set nofixendofline

" do not select a match in the menu. force the user to select one from the menu
" set completeopt& completeopt+=noselect

" for indenting Vim scripts, specifies the amount of indent for a continuation line, a line that the starts with a backslash
let g:vim_indent_cont = 0

" when editing a file, always jump to the last known cursor position
" don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" REF: defaults.vim
MyAutoCmd BufReadPost *
\ if line("'\"") >= 1 && line("'\"") <= line("$") |
\   execute "normal! g`\"" |
\ endif

" マウスはnormal, visualモードだけ使用
" マウスの移動でフォーカスを自動的に切替えない
" 入力時にマウスポインタを隠さない
set mouse=nv
set nomousefocus
set nomousehide

" kaoriya版のencode_japan.vimが作成した&fileencodingsは以下だった
" * guess,ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213,euc-jp
set fileencodings=ucs-bom,ucs-2le,ucs-2,iso-2022-jp-3,utf-8,euc-jisx0213,euc-jp
set fileformats=unix,dos

" undoファイルを一か所にまとめる
" スワップファイルを一か所にまとめる
set undodir=$VIMFILES/undo
call s:mkdir(&undodir)
set undofile

set directory=$VIMFILES/swap
call s:mkdir(&directory)
set swapfile

" バックアップを一か所にまとめる
" ファイルの上書きの前にバックアップを取る
" バックアップファイルの名前を指定する
set backupdir=$VIMFILES/backup
call s:mkdir(&backupdir)
set writebackup
set backup
MyAutoCmd BufWritePre * let &backupext = '_' . strftime('%Y%m%d') . '~'

" コマンド履歴の保存数を200に
set history=2000

" 親階層のtagsファイルも見る
set tags& tags+=tags tags+=./tags;

" markerを使用して折り畳み
set foldmethod=marker

" formatの指定
" set errorformat=%f(%l)\ :\ %t%*\D%n:\ %m,%*[^"]"%f"%*\D%:\ %m,%f(%l)\ :\ %m,%*[^\ ]\ %f\ %l:\ %m,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,%f|%l|\ %m
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m,%f

" :grepはrip grepを使用
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
endif

" 自動的にQuickFixを開く
" vimgrep使用時にはjオプションを付けること(着けないと勝手にジャンプしちゃうから
" TODO:helpgrepとかもジャンプしたくないけど、よく分からない
MyAutoCmd QuickfixCmdPost grep,vimgrep,helpgrep botright copen
MyAutoCmd QuickfixCmdPost lgrep,lvimgrep, botright lopen

" ']'というファイルを無駄に作成しないようにする(:w]というコマンドをよく実行しちゃっているっぽい)
" MyAutoCmd BufWritePre * if expand('<amatch>:t') == ']' | throw "oops!!!!!!!!!!" | endif
cnoreabbrev w] w

" printerの設定
if has('win32')
  set printfont=MS_Mincho:h12:cSHIFTJIS
endif

" jellybeanのコメントとかのitalic見づらいので、修正
" CursorLineもわかりづらいので微調整
let g:jellybeans_overrides = {
\   'TabLine':      {'guifg': 'ffffff', 'guibg': 'b0b8c0', 'ctermfg': '',      'ctermbg': 'Black', 'attr': ''    },
\   'TabLineSel':   {'guifg': '000000', 'guibg': 'f0f0f0', 'ctermfg': 'Black', 'ctermbg': 'White', 'attr': 'bold'},
\   'StatusLine':   {'guifg': '000000', 'guibg': 'dddddd', 'ctermfg': '',      'ctermbg': 'White', 'attr': ''    },
\   'Comment':      {'guifg': '888888', 'guibg': '',       'ctermfg': 'Grey',  'ctermbg': '',      'attr': ''    },
\   'StatusLineNC': {'guifg': 'ffffff', 'guibg': '403c41', 'ctermfg': 'White', 'ctermbg': 'Black', 'attr': ''    },
\   'Folded':       {'guifg': 'a0a8b0', 'guibg': '384048', 'ctermfg': 'Black', 'ctermbg': '',      'attr': ''    },
\   'CursorLine':   {'guifg': '',       'guibg': '2a2a2a', 'ctermfg': 'Black', 'ctermbg': '',      'attr': ''    },
\   'CursorColumn': {'guifg': '',       'guibg': '3a3a3a', 'ctermfg': 'Black', 'ctermbg': '',      'attr': ''    },
\ }

if has('vim_starting')
  if has('win32')
    colorscheme jellybeans
  else
    colorscheme desert
  endif
endif

" IME ON時のカーソルの色を設定(紫)
" 挿入モード・検索モードでのデフォルトのIME状態設定
highlight CursorIM guibg=Purple guifg=NONE
set iminsert=0
set imsearch=0
inoremap <silent> <Esc> <Esc>:set iminsert=0<CR>

if has('vim_starting')
  " ウインドウの幅、高さ
  set columns=210
  set lines=45
endif

" フォントサイズを指定
" 行間隔の設定
" 一部のUCS文字の幅を自動計測して決める(※linespace=autoはkaoriya版gvim限定)
set guifont=MS_Gothic:h9:cSHIFTJIS
" set linespace=1

if has('kaoriya')
  set ambiwidth=auto
else
  set ambiwidth=double
endif

" タブを常に表示
set showtabline=2

" 全てのイベントでベルが鳴らないようにする
set belloff=all

highlight default MyFlashy term=bold ctermbg=0 guibg=#13354A
highlight default TrailingSpaces guibg=darkgray

" MyAutoCmdとMyAutoCmdFTの強調
"   REF: http://pocke.hatenablog.com/entry/2014/06/21/101827
"   REF: sytanx/vim.vim
MyAutoCmd BufWinEnter,ColorScheme _vimrc,.vimrc,my_job.vimrc call s:my_hl_autocmd()
function! s:my_hl_autocmd() abort
  syntax keyword myVimAutoCmd MyAutoCmd skipwhite nextgroup=vimAutoEventList
  highlight link myVimAutoCmd vimAutoCmd

  syntax keyword myVimAutoCmdFT MyAutoCmdFT skipwhite nextgroup=vimAutoCmdSpace
  highlight link myVimAutoCmdFT vimAutoCmd
endfunction
call s:my_hl_autocmd()

" 末尾空白文字強調。vimfilerについてはしない
" REF: https://teratail.com/questions/71693
MyAutoCmd VimEnter,WinEnter,BufWinEnter * if &filetype ==# 'vimfiler' | match none | else | match TrailingSpaces /\s\+$/ | endif
MyAutoCmdFT vimfiler match none

" Windowを分割するマンなので、
" どのウィンドウにカーソルがあるかわかるように、Vimにfocusが戻ったら対象ウィンドウをハイライトする。
" MyAutoCmd FocusGained * call matchadd('Cursor', '\%#', 101)
MyAutoCmd FocusGained * call my#flash_window(1000, 'MyFlashy')

" http://qiita.com/kentaro/items/6aa9f108df825b2a8b39
MyAutoCmdFT ruby,vim silent execute 'lcd' my#get_root_dir()

" diffの設定
" REF: https://github.com/vim-jp/issues/issues/1206
" REF: https://vim-jp.org/blog/2018/12/12/new-diffopts-value.html
" MyAutoCmd FilterWritePre * call s:my_diff_settings()
" MyAutoCmd OptionSet diff if v:option_old == 0 && v:option_new == 1 | call s:my_diff_settings() | endif
MyAutoCmd DiffUpdated * call my#diff_settings()

" その他の各種設定
MyAutoCmdFT * call my#filetypes#setting(expand('<amatch>'))

" =================================
" = command: define

" - Copy file name
" - Copy file path
" - Copy file relative path
" - Copy root direcotory name
" - Copy root direcotory path
command! Cfn call my#echo_and_yank(expand('%:t'))
command! Cfp call my#echo_and_yank(expand('%:p'))
command! Cfr call my#echo_and_yank(substitute(expand('%'), '^\', '', 'g'))
command! Cdn call my#echo_and_yank(substitute(my#get_root_dir(expand('%:p')), '.*\\', '', 'g'))
command! Cdp call my#echo_and_yank(my#get_root_dir(expand('%:p')))
command! CfpConvSeparator call my#echo_and_yank(substitute(expand('%:p'), '\', '/', 'g'))
command! CfrConvSeparator call my#echo_and_yank(substitute(substitute(expand('%'), '^\', '', 'g'), '\' , '/', 'g'))
command! CdpConvSeparator call my#echo_and_yank(substitute(my#get_root_dir(expand('%:p')), '\', '/', 'g'))

" 選択範囲内の数値の合計
command! -range Sum      call my#sum(0)
command! -range SumFloat call my#sum(1)

" よく使うファイルとか
command! EVimrc edit $MYVIMRC
command! ERunVimrc edit $VIMFILES/run.vim
command! EFiletypeSetting edit $VIMFILES/autoload/my/filetypes.vim
command! ReflectVimrc source $MYVIMRC
command! RunVimScript source $VIMFILES/run.vim

" 開いているファイルに移動(元: plugins/kaoriya/plugin/cmdex.vim)
command! CdCurrent cd %:p:h

if has('win32') && executable('touch')
  command! Touch if &modified | call my#error_msg('modified file!') | else | silent execute '!start touch' expand('%:p') | endif
endif

command! MinpacUpdate call minpac#update('', {'do': 'call minpac#status()'})

if has('win32')
  command! TCurrent if empty(bufname("%")) | throw 'Current buffer is [No Name]!!' | endif | terminal ++close cmd /k cd /d "%:p:h" & set LANG=ja_JP.UTF-8
endif

" " REF: https://github.com/vim-jp/issues/issues/1204
" command! TDotfiles :terminal ++close cmd /k cd /d "<C-r>=expand($HOME)<CR>/dotfiles" & set LANG=ja_JP.UTF-8
command! TDotfiles execute 'terminal ++close cmd /k cd /d ' . expand($HOME) . '\dotfiles & set LANG=ja_JP.UTF-8'

" REF: http://secret-garden.hatenablog.com/entry/2018/02/05/190925
command! -nargs=* Debug try | echomsg <q-args> ":" string(<args>) | catch | echomsg <q-args> | endtry

" =================================
" = mapping: initialize

" mapleaderに','を指定
let g:mapleader = ','

" 以下をNop
" * 直前に挿入されたテキストをもう一度挿入し、挿入を終了(C-@, 誤タイプ防止)
" * 保存して閉じる(ZZ, 誤タイプ防止)
" * 保存せず閉じる(ZQ, 誤タイプ防止)
" * Exモードに入る(Q, gQ, 誤タイプ防止)
" * f, t, F, Tの繰り返し(; clever-f使うのでいらない)
" * 後方検索 (#, vim-asterisk使ってから全く使わなくなったから)
" * 後方検索 (?, 何故か全く使わないから。incsearch-stay使っているからかも)
inoremap <C-@> <Nop>
nnoremap ZZ    <Nop>
nnoremap ZQ    <Nop>
nnoremap Q     <Nop>
nnoremap gQ    <Nop>
onoremap ;     <NOP>
nnoremap #     <NOP>
nnoremap g#    <NOP>
noremap  ?     <NOP>

" prefix keyとして z, <Space>を使用
" - ウィンドウ移動系の操作にs使ってたけど
"   このvimrcがない環境だとs使って意図しない編集しまくりだったので、sは基本使わないようにする
" - その次にtを使ってたけど
"   Vim本来のt(右方向への指定文字前ジャンプ)を結構使うようになったので、prefixにzを使う
nnoremap z       <Nop>
xnoremap z       <Nop>
nnoremap <SPACE> <Nop>
xnoremap <SPACE> <Nop>
nnoremap s       <Nop>
xnoremap s       <Nop>

" windowの生成, 移動のprefixにzを使っちゃったので、;にzを割り当て
nnoremap ; z
xnoremap ; z

" =================================
" = mapping: (Plugin)vim-quickhl

nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

let g:quickhl_manual_colors = [
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
   \ "cterm=bold ctermfg=7  ctermbg=56  gui=bold guibg=#a0b0c0 guifg=black",
   \ ]

" =================================
" = mapping: (Plugin)clever-f.vim

nmap f <Plug>(clever-f-f)
nmap F <Plug>(clever-f-F)
nmap t <Plug>(clever-f-t)
nmap T <Plug>(clever-f-T)
xmap f <Plug>(clever-f-f)
xmap F <Plug>(clever-f-F)
xmap t <Plug>(clever-f-t)
xmap T <Plug>(clever-f-T)

" =================================
" = mapping: (Plugin)vim-clurin

nmap + <Plug>(clurin-next)
nmap - <Plug>(clurin-prev)
xmap + <Plug>(clurin-next)
xmap - <Plug>(clurin-prev)

" =================================
" = mapping: (Plugin)vim-easymotion

" 2-key Find Motion
map <Leader>S <Plug>(easymotion-s2)

" f,F,t,Tのオペレータ待機の時だけはclever-f使わないでeasymotion使う
" omap t <Plug>(easymotion-tl)
" omap T <Plug>(easymotion-Tl)
" omap f <Plug>(easymotion-fl)
" omap F <Plug>(easymotion-Fl)

" =================================
" = mapping: (Plugin)vim-operator-replace

nmap <Leader>r <Plug>(operator-replace)

" 個人的なシュミでselect modeのマッピングはしたくないけど、neosnippet用にsmapでも動作するようにしておく
vmap <Leader>r <Plug>(operator-replace)

" =================================
" = mapping: (Plugin)vim-sandwich
xmap sd <Plug>(operator-sandwich-delete)
xmap sr <Plug>(operator-sandwich-replace)
nmap sa <Plug>(operator-sandwich-add)iw
nmap sA <Plug>(operator-sandwich-add)iW
xmap sa <Plug>(operator-sandwich-add)

" REF: vim-sandwich/plugin/sandwich.vim
nmap sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
nmap sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

" =================================
" = mapping: (Plugin)vim-operator-flashy

map y <Plug>(operator-flashy)
nmap Y <Plug>(operator-flashy)$

" =================================
" = mapping: (Plugin)vim-easy-align

xmap <CR> <Plug>(EasyAlign)

" =================================
" = mapping: (Plugin)incsearch.vim

if v:version < 801
  map / <plug>(incsearch-forward)
endif
map z/ <Plug>(incsearch-stay)

" クリップボードから検索(改行に対応)
" nmap g/ /<C-u>\V<C-r>=escape(@+, '\/')<CR><CR>
nmap g/ /<C-u>\V<C-r>=join(map(getreg("+", 1, 1), {key, val -> escape(val, '\/')}), "\\n")<CR><CR>

" =================================
" = mapping: (Plugin)vim-anzu & vim-asterisk

" ステータスラインに検索ヒット数を表示
" 検索のechoとanzuのechoでちらつくので、silentをはさんでから<Plug>(anzu-echo-search-status)を実施
" 9nとした場合には一番最後の検索結果にジャンプ
" n,Nタイプ時にちらかないように(incsearchの"/xxxx"が表示されないよう)silent指定する
nnoremap <silent> <Plug>(my-anzu-jump-n) :<C-u>silent execute 'normal' (v:count == 0 ? "\<Plug>(anzu-n)" : (v:count == 9 ? "G\<Plug>(anzu-N)" : v:count."\<Plug>(anzu-jump-n)"))<CR>
nnoremap <silent> <Plug>(my-anzu-N) :<C-u>silent execute 'normal' "\<Plug>(anzu-N)"<CR>

nmap n <Plug>(my-anzu-jump-n)<Plug>(anzu-echo-search-status)<Plug>(my-flash-search-ward)
nmap N <Plug>(my-anzu-N)<Plug>(anzu-echo-search-status)<Plug>(my-flash-search-ward)
nmap <C-n> <Plug>(my-anzu-jump-n);z<Plug>(anzu-echo-search-status)<Plug>(my-flash-search-ward)
nmap <C-p> <Plug>(my-anzu-N);z<Plug>(anzu-echo-search-status)<Plug>(my-flash-search-ward)

map *  <Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)<Plug>(my-flash-search-ward)
map g* <Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)<Plug>(my-flash-search-ward)

" 行検索
nmap <Leader>*  :<C-u>normal! g_<CR>v_<Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)<Plug>(my-flash-search-ward)
nmap <Leader>g* :<C-u>normal! g_<CR>v_<Plug>(asterisk-gz*)<Plug>(anzu-update-search-status-with-echo)<Plug>(my-flash-search-ward)

" =================================
" = mapping: (Plugin)unite.vim & vimfiler.vim

" 多用
nnoremap <Space>ec :<C-u>VimFilerBufferDir -winwidth=60 -explorer  -no-toggle<CR>
nnoremap <Space>ee :<C-u>VimFilerExplorer  -winwidth=60<CR>
nnoremap <Space>ef :<C-u>VimFilerBufferDir -winwidth=60 -explorer  -find<CR>
nnoremap <Space>ep :<C-u>VimFilerExplorer  -winwidth=60 -no-toggle <C-r>=expand($VIMFILES)<CR>/pack<CR>
nnoremap <Space>ev :<C-u>VimFilerExplorer  -winwidth=60 -no-toggle <C-r>=expand($VIM)<CR><CR>
nnoremap <Space>eh :<C-u>VimFilerExplorer  -winwidth=60 -no-toggle <C-r>=expand($HOME)<CR><CR>
nnoremap <Space>ed :<C-u>VimFilerExplorer  -winwidth=60 -no-toggle <C-r>=expand($HOME)<CR>/dotfiles<CR>
nnoremap <Space>er :<C-u>VimFilerBufferDir -winwidth=60 -no-toggle -explorer -project<CR>

" 多用
nnoremap <Space>f  :<C-u>Unite -buffer-name=proj_file_mru neomru/file<CR>
nnoremap <Space>F  :<C-u>Unite -buffer-name=file_mru file_mru<CR>
nnoremap <Space>bo :<C-u>Unite -buffer-name=bookmark bookmark<CR>
nnoremap <Space>bu :<C-u>Unite -buffer-name=buffer buffer<CR>
nnoremap <Space>R  :<C-u>UniteResume<CR>

" たまに使う
nnoremap <Space>ol :<C-u>Unite -create -vertical -no-quit -winwidth=50 -direction=botright -no-start-insert outline<CR>
nnoremap <Space>op :<C-u>Unite -buffer-name=output output:<CR>
nnoremap <Space>hy :<C-u>Unite -buffer-name=history_yank history/yank<CR>
nnoremap <Space>w  :<C-u>Unite -buffer-name=window window:all<CR>
nnoremap <Space>qr :<C-u>Unite -buffer-name=register register<CR>

nnoremap <Leader><Leader>f :<C-u>UniteWithBufferDir -buffer-name=buffer_dir_file file<CR>

" NOTE: unite outlineが-buffer-name指定するとなんか動きおかしい
" nnoremap <Space>ol :<C-u>Unite -buffer-name=outline -vertical -no-quit -winwidth=50 -direction=botright -no-start-insert outline<CR>

" =================================
" = mapping: (Plugin)caw.vim

" コメントのトグル
nmap <Space>/ <Plug>(caw:hatpos:toggle)
xmap <Space>/ <Plug>(caw:hatpos:toggle)
map <Leader>/ <Plug>(caw:hatpos:toggle:operator)

" 行コピーしてペーストしてコメントアウト
" REF: http://d.hatena.ne.jp/osyo-manga/20120303/1330731434
nmap <Space>_ yy<Plug>(caw:hatpos:toggle)p
xmap <Space>_ :yank<CR>gv<Plug>(caw:hatpos:toggle)`>p

" =================================
" = mapping: (Plugin)vim-textobj-from_regexp

" REF: https://gist.githubusercontent.com/mattn/fecf0ce486192d83a95d93bdcd5def09/raw/9d0c0a19e4292ffdb1be21daf1ad3c5d8d06df01/textobj.vim

omap <expr> i# textobj#from_regexp#mapexpr('#\zs.\{-}\ze#')
xmap <expr> i# textobj#from_regexp#mapexpr('#\zs.\{-}\ze#')

omap <expr> i_ textobj#from_regexp#mapexpr('_\zs.\{-}\ze_')
xmap <expr> i_ textobj#from_regexp#mapexpr('_\zs.\{-}\ze_')

" =================================
" = mapping: (Plugin)vim-textobj-parameter

omap ao <Plug>(textobj-parameter-a)
omap io <Plug>(textobj-parameter-i)
xmap ao <Plug>(textobj-parameter-a)
xmap io <Plug>(textobj-parameter-i)

" =================================
" = mapping: (Plugin)vim-textobj-indent

" <Plug>(textobj-indent-i)は使わない
omap ai <Plug>(textobj-indent-a)
omap ii <Plug>(textobj-indent-a)
xmap ai <Plug>(textobj-indent-a)
xmap ii <Plug>(textobj-indent-a)

" =================================
" = mapping: (Plugin)vim-textobj-multiblock

" 全角の「」, （）、【】にも反応するように追加
" 使うときにコメントアウトを取る
" let g:textobj_multiblock_blocks = [
" \   ['「', '」'],
" \   ['（', '）'],
" \   ['|', '|', 1],
" \ ]

omap aq <Plug>(textobj-multiblock-a)
omap iq <Plug>(textobj-multiblock-i)
xmap aq <Plug>(textobj-multiblock-a)
xmap iq <Plug>(textobj-multiblock-i)

" =================================
" = mapping: (Plugin)vim-jplus

" nmap J <Plug>(jplus)
" xmap J <Plug>(jplus)
nmap <Leader>J <Plug>(jplus-input)
xmap <Leader>J <Plug>(jplus-input)

" =================================
" = mapping: (Plugin)vim-quickrun

" <CR>付けない
nnoremap <Leader>R :QuickRun
xnoremap <Leader>R :QuickRun

" =================================
" = mapping: (Plugin)open-browser.vim

nmap <Leader>ob <Plug>(openbrowser-smart-search)
xmap <Leader>ob <Plug>(openbrowser-smart-search)
nnoremap <Leader>og :OpenBrowser https://github.com/<C-r>=expand('<cfile>')<CR><CR>
xnoremap <Leader>og :<C-u>OpenBrowser https://github.com/<C-r>=my#selected_text()<CR><CR>

" =================================
" = mapping: (Plugin)vim-textmanip

xmap <Down>  <Plug>(textmanip-move-down-r)
xmap <Up>    <Plug>(textmanip-move-up-r)
xmap <Left>  <Plug>(textmanip-move-left-r)
xmap <Right> <Plug>(textmanip-move-right-r)

xmap <C-Down>  <Plug>(textmanip-duplicate-down)
xmap <C-Up>    <Plug>(textmanip-duplicate-up)
nmap <C-Down>  <Plug>(textmanip-duplicate-down)
nmap <C-Up>    <Plug>(textmanip-duplicate-up)

" nmap <F10>   <Plug>(textmanip-toggle-mode)
" xmap <F10>   <Plug>(textmanip-toggle-mode)

" =================================
" = mapping: (Plugin)memolist.vim

nnoremap <Leader>mn :<C-u>MemoNew<CR>task<CR>
nnoremap <Leader>ml :<C-u>MemoList<CR>
nnoremap <leader>mo :<C-u>call my#copy_or_open_past_file(g:memolist_path, '%Y-%m-%d', '-task.' . g:memolist_memo_suffix, 1, 12, 0)<CR>
nnoremap <leader>mc :<C-u>call my#copy_or_open_past_file(g:memolist_path, '%Y-%m-%d', '-task.' . g:memolist_memo_suffix, 1, 12, 1)<CR>
\ :1,3s/\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d/\=strftime(g:memolist_memo_date)/g<CR>

" =================================
" = mapping: (Plugin)vim-edgemotion

map <C-j> <Plug>(edgemotion-j)
map <C-k> <Plug>(edgemotion-k)

" =================================
" = mapping: (Plugin)neosnippet.vim, neocomplete.vim
" = mapping: (vim-edgemotion)

imap <expr> <C-k> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<C-k>"
smap <expr> <C-k> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<Plug>(edgemotion-k)"
" imap <expr> <C-l> neocomplete#start_manual_complete('neosnippet')

" =================================
" = mapping: window operation
" http://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
"
" prefixはzを使用
" つぶしたzは;に割り当てる
"
" prefixをsにしたらこのvimrcがない場所で、
" 意図しない編集しまくりだったので、zにした

" activeなwindowの変更
nnoremap <silent> zh <C-w>h
nnoremap <silent> zj <C-w>j
nnoremap <silent> zk <C-w>k
nnoremap <silent> zl <C-w>l
nnoremap <silent> zw <C-w>w
nnoremap <silent> zW <C-w>W
nnoremap <silent> zb <C-w>b
nnoremap <silent> zt <C-w>t
nmap zc <Plug>(choosewin)

" windowの移動
nnoremap <silent> zH <C-w>H
nnoremap <silent> zJ <C-w>J
nnoremap <silent> zK <C-w>K
nnoremap <silent> zL <C-w>L
nnoremap <silent> zT <C-w>T
nnoremap <silent> zr <C-w>r
nnoremap <silent> zR <C-w>R
nnoremap <silent> zp <C-w>p
nnoremap <silent> zx <C-w>x
nnoremap <silent> zP <C-w>P

" windowサイズの変更
nnoremap <silent> z= <C-w>=
nnoremap <silent> z<BAR> <C-w><BAR>
nnoremap <silent> z_ <C-w>_
nnoremap <silent> z1<BAR> <C-w>1<BAR>
nnoremap <silent> z1_ <C-w>1_
nnoremap <silent> zo <C-w>_<C-w><BAR>

" 新規window, tabの生成
nnoremap <silent> zs :<C-u>split<CR>
nnoremap <silent> zv :<C-u>vsplit<CR>
nnoremap <silent> zS :<C-u>new<CR>
nnoremap <silent> zV :<C-u>vnew<CR>
nnoremap <silent> zN :<C-u>tabnew<CR>

" windowを閉じる, 新規ウィンドウにする
nnoremap <silent> zO :<C-u>only<CR>
nnoremap <silent> zE :<C-u>enew<CR>

" カレントBuffer以外閉じる
nnoremap z<C-o> :<C-u>tabonly <BAR> only

" Windowを分割してタグジャンプ
nnoremap <silent> z]v :<C-u>vsplit<CR>g<C-]>
nnoremap <silent> z]s :<C-u>split<CR>g<C-]>

" Windowを分割して検索
" nnoremap <silent> z/v :<C-u>vsplit<CR>/
" nnoremap <silent> z/s :<C-u>split<CR>/

" =================================
" = mapping: cursor move

" カーソル移動
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
inoremap <C-a> <Home>
inoremap <C-b> <Left>
inoremap <C-f> <Right>

" カーソル移動(補完用ポップアップ表示中じゃなければ)
" どこかのサイトでpumvisibleじゃなくて、mode(?)を見ろみたいなことが書かれていたような。
" 忘れた。。
inoremap <expr> <C-e> pumvisible() ? '<C-e>' : '<End>'

" カーソルを表示行で移動する。
nnoremap j gj
xnoremap j gj
nnoremap k gk
xnoremap k gk

" vを二回で行末まで選択
xnoremap v $h

" スクロール時の調整
nnoremap <C-e> <C-e>j
nnoremap <C-y> <C-y>k

" カーソル位置起点でのマークへのジャンプ
noremap mj ]'
noremap mk ['

" =================================
" = mapping: ctags & cscope

" ctags
nmap <Leader>ct <Plug>(my-do-ctags)
nmap <Leader>cT <Plug>(my-do-ctags-all)

" cscope
nmap <Leader>csb <Plug>(my-cscope-build)
nmap <Leader>csa <Plug>(my-cscope-add)
nnoremap <Leader>css :<C-u>cscope show<CR>
nnoremap <Leader>csk :<C-u>cscope kill -1<CR>
nnoremap <Leader>csfc :<C-u>cscope find c <C-r>=expand('<cword>')<CR><CR>
nnoremap <Leader>csfC :<C-u>cscope find c <C-r>=@+<CR><CR>
nnoremap <Leader>csfs :<C-u>cscope find s <C-r>=expand('<cword>')<CR><CR>
nnoremap <Leader>csfS :<C-u>cscope find s <C-r>=@+<CR><CR>

" =================================
" = mapping: other

" save
nnoremap <Leader>w :<C-u>w<CR>

" :cnext, :cprev :cclose
nnoremap gl :<C-u>cnext<CR>zz
nnoremap gh :<C-u>cprev<CR>zz
nnoremap gk :<C-u>copen<CR>
nnoremap gj :<C-u>cclose<CR>

" 明示的に \ を付けて改行する
imap <C-CR> <Plug>(my-back-slash-linefeed)

if has('win32')
  " 開いているファイルを選択した状態でExplorerを開く
  " 開いているファイルのルートディレクトリを開く
  " (ge, gE全く使っていないのでつぶしちゃう)
  nnoremap ge :<C-u>!start explorer /e,/select,%<CR>
  nnoremap gE :<C-u>!start explorer /select,<C-r>=my#get_root_dir(expand('%:p'))<CR><CR>

  " カーソル下のファイルをstartで実行
  " REF: https://github.com/vim-jp/issues/issues/1220
  nnoremap gx :<C-u>!start <C-r>=expand('<cfile>:p')<CR><CR>
endif


" insertの<S-CR>でカーソルが行途中にあっても改行ができるようにする。
" leximaのendwiseも動いてほしく、lexima#expand()を呼び出す前にカーソル位置を移動させる必要があり、
" 無理やりcursor()を呼び出している
" NOTE: expr指定時にはcursor位置変えても自動(タイミング不明)でカーソルが元の場所に戻る。。(ちゃんとヘルプに書いてあるのがすごい)
" inoremap <silent><expr> <S-CR> '<C-r>=cursor(line('.'), 10000)<CR><BS>' . lexima#expand("\<LT>CR>", 'i')
inoremap <silent><expr> <S-CR> '<C-r>=cursor(line("."), 10000)<CR><BS>' . lexima#expand("\<LT>CR>", 'i')

" normalでもleximaを呼び出したいので、feedkeysを使用して実現
" NOTE: nnoremap 123 :<C-u>call feedkeys("\<CR>")<CR> と書いた場合、123とタイプすると以下が実行される
"       : call feedkeys("\
"       ")
"       ↑のように二行分のスクリプトが実行され123タイプでエラーとなってしまうので、\<CR>ではなく、\<LT>CR>と記載する必要がある。
nnoremap <silent> <CR> :<C-u>call feedkeys("A\<LT>CR>")<CR>

" ^はあんまり使わない(_を使う)ので他に割り当て
nnoremap ^ :<C-u>Cfp<CR>

" H,Lを拡張
nmap H <Plug>(my-H)
nmap L <Plug>(my-L)
xmap H <Plug>(my-H)
xmap L <Plug>(my-L)

" _を少し拡張
nmap _ <Plug>(my-underscore)
xmap _ <Plug>(my-underscore)

" カーソルを動かさずに全体をコピー、削除
nmap yie <Plug>(my-flash-window-and-yank-entire)
nnoremap die :<C-u>%d<CR>
xnoremap ie  <Esc>ggVG

" " :h ins-completion

" <C-x><C-l> : 行全体
" <C-x><C-n> : 現在のファイルのキーワード
" <C-x><C-k> : 'dictionary' のキーワード
" <C-x><C-t> : 'thesaurus' のキーワード, thesaurus-style
" <C-x><C-i> : 編集中と外部参照しているファイルのキーワード
" <C-x><C-]> : タグ
" <C-x><C-f> : ファイル名
" <C-x><C-d> : 定義もしくはマクロ
" <C-x><C-v> : Vimのコマンドライン
" <C-x><C-o> : オムニ補完
"
" " 設定したけど全然使わなかった
" inoremap jjl <C-x><C-l>
" inoremap jjn <C-x><C-n>
" inoremap jjk <C-x><C-k>
" inoremap jjt <C-x><C-t>
" inoremap jji <C-x><C-i>
" inoremap jj] <C-x><C-]>
" inoremap jjf <C-x><C-f>
" inoremap jjd <C-x><C-d>
" inoremap jjv <C-x><C-v>
" inoremap jjo <C-x><C-o>

" <C-x><C-u> : ユーザー定義補完
" <C-x><C-s> : スペリング補完
" inoremap jju <C-x><C-u>
" inoremap jjs <C-x><C-s>

" incsearch.vimを使わずにvimの/を使って検索
" ファイルサーバ上のファイルだとincsearch.vim重くなる。。
nnoremap X /

" 置換, vimgrep, lvimgrepのコマンドを簡略化
nnoremap <expr> gs v:count == 0 ? ':<C-u>%s///g<Left><Left>' : 'gs'
xnoremap gs :s///g<Left><Left>
nnoremap gc :<C-u>vimgrep //j %<Left><Left><Left><Left>
nnoremap gC :<C-u>vimgrep /<C-r><C-w>/j %<CR>

" global, vglobalコマンド
nnoremap gV :<C-u>v//d
xnoremap gV :v//d
nnoremap gG :<C-u>g//d
xnoremap gG :g//d

" <S-UP>で日付、<S-DOWN>で時刻の入力
nnoremap <silent> <S-UP>   <Esc>i<C-g>u<C-r>=strftime('%Y.%m.%d')<CR><Esc>
nnoremap <silent> <S-DOWN> <Esc>i<C-g>u<C-r>=strftime('%H:%M:%S')<CR><Esc>
inoremap <expr>   <S-UP>   strftime('%Y.%m.%d')
inoremap <expr>   <S-DOWN> strftime('%H:%M:%S')
xnoremap <silent> <S-UP>   c<C-g>u<C-r>=strftime('%Y.%m.%d')<CR><Esc>
xnoremap <silent> <S-DOWN> c<C-g>u<C-r>=strftime('%H:%M:%S')<CR><Esc>

" insertモード時にundo地点を新たに設定する
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
" inoremap <CR> <C-g>u<CR>

" ,で,<Space>
inoremap , ,<Space>

" 短縮入力が起動しないようにする
inoremap <Space> <Space>

" normalモードでの<Esc>で以下をクリア(<C-l>も同じようにしておく)
" * clever-f
" * 検索ハイライト
" * anzu(空文字列のechoで消す)
nnoremap <silent> <Esc> :<C-u>call clever_f#reset()<CR>:<C-u>nohlsearch<CR>:<C-u>echo<CR>
nnoremap <silent> <C-l> :<C-u>call clever_f#reset()<CR>:<C-u>nohlsearch<CR>:<C-u>echo<CR><C-l>

" gFは右側にsplitしたウィンドウで開く
nnoremap  gF :<C-u>vertical botright wincmd F<CR>zz

" insertモード,commandモードのC-yでクリップボードからペースト
cnoremap <C-y> <C-r>+
inoremap <expr> <C-y> pumvisible() ? '<C-y>' : '<C-g>u<C-r>+'

" <Up><Down>を割り当て
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" visualモードでの<Esc>は選択開始位置に戻ってから終了
" gvはoを使ってビジュアルモードで最後に選択していたカーソル位置にカーソルを戻す
xnoremap <Esc> o<Esc>
nnoremap gv gvo

" vimrcを開く
nnoremap <Space>. :<C-u>EVimrc<CR>

" タグジャンプ時に複数候補表示
nnoremap <C-]> g<C-]>
nnoremap g<C-]> :<C-u>tjump <C-r>=@+<CR><CR>

if has('win32')
  " Tortoise svn diff, log, blame, repobrowser
  nnoremap <silent> <Leader>td  :<C-u>execute '!start TortoiseProc.exe /command:diff /path:"' . expand("%:p") . '" /ignoreprops'<CR>
  nnoremap <silent> <Leader>tb  :<C-u>execute '!start TortoiseProc.exe /command:blame /path:"' . expand("%:p") . '" /line:' . line(".")<CR>
  nnoremap <silent> <Leader>tr  :<C-u>execute '!start TortoiseProc.exe /command:repobrowser'<CR>
  nnoremap <silent> <Leader>tf  :<C-u>execute '!start TortoiseProc.exe /command:repostatus /path:"' . my#get_root_dir(expand('%:p')) . '"'<CR>
  nnoremap <silent> <Leader>tl  :<C-u>execute '!start TortoiseProc.exe /command:log /path:"' . my#get_root_dir(expand('%:p')) . '" /strict'<CR>
  nnoremap <silent> <Leader>tcl :<C-u>execute '!start TortoiseProc.exe /command:log /path:"' . expand("%:p") . '" /strict'<CR>
endif

" diff
nnoremap <Leader>qw :<C-u>windo diffthis<CR>
nnoremap <Leader>qo :<C-u>windo diffoff<CR>
nnoremap <Leader>qO :<C-u>bufdo diffoff<CR>
nnoremap <Leader>qu :<C-u>diffupdate<CR>
nnoremap <Leader>>  :<C-u>diffput<CR>
nnoremap ]c ]czz
nnoremap [c [czz

" spell
nnoremap ]s ]szz
nnoremap [s [szz
nnoremap zg zg
nnoremap zG zG

" dk が dj と対象となるようにする
" REF: https://github.com/cohama/.vim/blob/72d1d536ad4422e29d339fcda7eae19ba56b309d/.vimrc#L1068-L1069
nnoremap <expr> dk line('.') == line('$') ? 'dk' : 'dkk'

" 短縮入力にユーザ定義補完を使う
" inoremap <C-]> <C-x><C-u>

" <F1>でpasteのtoggle(他と合わせてなんとなくpastetoggleは使わない)
" <F2>は別で使っているので、指定しないあるので
" <F4>でwrapのtoggle
" <F9>で透過度を50 <-> 255に変更
" <F12>でフォントサイズを9 <-> 16に変更
nnoremap <F1> :<C-u>set paste!<CR>
nnoremap <F4> :<C-u>set wrap!<CR>
nmap <F9> <Plug>(my-toggle-transparency)
nmap <F12> <Plug>(my-toggle-fontsize)
" nnoremap <F12> :<C-u>set guifont=*<CR>

" ================================
" = for private job

if filereadable($HOME . '/my_job.vimrc')
  source $HOME/my_job.vimrc

  if has('win32')
    call altr#define('_vimrc', 'my_job.vimrc')
  else
    call altr#define('.vimrc', 'my_job.vimrc')
  endif
endif

" vim-lsp
if executable('golsp')
  MyAutoCmd User lsp_setup call lsp#register_server({
      \   'name': 'go-lang',
      \   'cmd': {server_info->['golsp']},
      \   'whitelist': ['go'],
      \ })
endif

" ===========================
" NOTE: vim とか cmd.exeとか

" Window内の数値を1000で除算した後に\d.\d\d\d\に変更
" %s#\d\+#\=printf("%.3f",submatch(0) / 1000.0)#g

" 色設定のテスト
" :runtime syntax/colortest.vim
"
" ハイライトグループのテスト
" :so $VIMRUNTIME/syntax/hitest.vim
"
" 文字コード変換
" :e ++enc=sjis
"
" 改行コード変換
"
" Vimからtortoisesvn呼び出し
" REF: http://blog.blueblack.net/item_144
"
" treeコマンド
" !tree /F
"
" 最短一致 : \{-}
"
" ascii以外の文字検索/[^\t -~]
" REF: http://vimwiki.net/?RegexQA%2F2
"
" 否定先読み
" \s*function\(.*abort$\)\@!  |  後ろに "abort" がない "function"
"
" 否定後読み
" \(foo\)\@<!bar    |  前に "foo" がない "bar"
" \(\/\/.*\)\@<!in  |  前に "//" がない "in" (あってる？)
" REF: :h \@<!
"
" :vimgrep で再帰的に検索
" :vim /hoge/j .vim/**/*.vim
" :vim /hoge/j *.vim .vim/**/* (↑と一緒？) # => 違う。(:vimgrepは検索場所を複数指定できる。)
"
" cmd.exe /K"title=hello"
"
" binary ファイルの編集(http://d.hatena.ne.jp/rdera/20081022/1224682665)
" $vim -b file.bin
" :%!xxd
" :%!xxd -r (16進数表記部分の更新が反映されるやつ)
"
" 文字コードでの文字の入力
" <C-v>x41 -> A
" <C-v>uxxxxでUnicodeでの入力もいける
"
" オプション変更時にecho
" MyAutoCmd OptionSet * execute 'echomsg "' . expand('<amatch>') . ', ' . 'old value:' .  string(v:option_old) . ' new value:' . string(v:option_new) . ' type:' . v:option_type . '"'
"
" GUIからfontを変更
" :<C-u>set guifont=*<CR>
"
" :caddbuffer "カレントバッファーを使ってquickfixを表示する
"
" let str = "おかえりなさい"
" call map(reverse(split(str, '\ze')), {key, value -> execute("echo '". value . "'")})
"
" vim:set et ts=2 sts=2 sw=2 tw=0 ft=vim:
