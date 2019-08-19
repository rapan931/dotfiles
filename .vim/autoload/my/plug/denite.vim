" function! my#plug#denite#init() abort
"   call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git', '--glob', '!.svn'])
"
"   call denite#custom#var('grep', 'command', ['rg'])
"   call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '--no-heading'])
"   call denite#custom#var('grep', 'recursive_opts', [])
"   call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
"   call denite#custom#var('grep', 'separator', ['--'])
"   call denite#custom#var('grep', 'final_opts', [])
"
"   " custom option
"   call denite#custom#option('_', {'start_filter': 1})
"
"   " alias
"   call denite#custom#alias('source', 'proj_file_mru', 'file_mru')
"   call denite#custom#source('file_mru', 'matchers', ['matcher/substring'])
"   call denite#custom#source('proj_file_mru', 'matchers', ['matcher/substring', 'matcher/project_files'])
"
"   " mru
"   let g:neomru#file_mru_ignore_pattern = '\~$\|\.\%(o\|exe\|dll\|bak\|sw[po]\)$\|\%(^\|/\)\.\%(git\|svn\)\%($\|/\)\|^\%(//\|\\\\\)'
"
" endfunction
