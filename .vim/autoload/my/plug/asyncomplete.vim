function! my#plug#asyncomplete#init() abort
  if executable('css-languageserver')
      au User lsp_setup call lsp#register_server({
          \ 'name': 'css-languageserver',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
          \ 'whitelist': ['css', 'less', 'sass'],
          \ })
  endif


  " let s:always_black_list = ['unite', 'txt', '']
  " call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
  "      \   'name': 'necovim',
  "      \   'whitelist': ['vim'],
  "      \   'completor': function('asyncomplete#sources#necovim#completor'),
  "      \ }))
  "
  " call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
  "      \   'name': 'neosnippet',
  "      \   'whitelist': ['*'],
  "      \   'blacklist': s:always_black_list,
  "      \   'completor': function('asyncomplete#sources#neosnippet#completor'),
  "      \ }))
  "
  " " call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
  "       "\   'name': 'buffer',
  "       "\   'whitelist': ['*'],
  "       "\   'blacklist': ['go'] + s:always_black_list,
  "       "\   'completor': function('asyncomplete#sources#buffer#completor'),
  "       "\   'config': {
  "       "\      'max_buffer_size': 5000000,
  "       "\   },
  "       "\ }))
endfunction

