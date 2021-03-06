scriptencoding utf-8
if exists('g:loaded_my')
  finish
endif
let g:loaded_my = 1

let s:save_cpo = &cpo
set cpo&vim


nnoremap <silent> <Plug>(my-H)  :<C-u>call my#HL('H', 0)<CR>
nnoremap <silent> <Plug>(my-L)  :<C-u>call my#HL('L', 0)<CR>
xnoremap <silent> <Plug>(my-H)  :<C-u>call my#HL('H', 1)<CR>
xnoremap <silent> <Plug>(my-L)  :<C-u>call my#HL('L', 1)<CR>

nnoremap <silent> <Plug>(my-underscore) :<C-u>call my#underscore('_', 0)<CR>
xnoremap <silent> <Plug>(my-underscore) :<C-u>call my#underscore('_', 1)<CR>

nnoremap <silent> <Plug>(my-flash-window) :<C-u>call my#flash_window(300, 'MyFlashy')<CR>
nnoremap <silent> <Plug>(my-flash-window-and-yank-entire) :<C-u>%y<CR>:<C-u>call my#flash_window(500, 'MyFlashy')<CR>
nnoremap <silent> <Plug>(my-flash-search-word) :<C-u>call my#flash_search_word(300)<CR>

nnoremap <silent> <Plug>(my-toggle-fontsize) :<C-u>call my#toggle_fontsize()<CR>
nnoremap <silent> <Plug>(my-toggle-transparency) :<C-u>call my#toggle_transparency()<CR>

nnoremap <silent> <Plug>(my-do-ctags) :<C-u>call my#do_ctags(0)<CR>
nnoremap <silent> <Plug>(my-do-ctags-all) :<C-u>call my#do_ctags(1)<CR>

nnoremap <silent> <Plug>(my-cscope-build) :<C-u>call my#cscope_build()<CR>
nnoremap <silent> <Plug>(my-cscope-add) :<C-u>call my#cscope_add()<CR>

inoremap <silent> <Plug>(my-back-slash-linefeed) <CR><C-r>=my#back_slash_linefeed()<CR><End>

nnoremap <silent> <Plug>(my-gf) :<C-u>call my#gf()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
