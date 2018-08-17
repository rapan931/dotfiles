function! my#complete#ripgrep(arglead, cmdline, cursorpos) abort
  let ret = [
  \   '-0', '-A', '-B', '-C', '-E', '-F', '-H', '-L', '-M',
  \   '-N', '-S', '-T', '-V', '-a', '-c', '-e', '-f', '-g',
  \   '-h', '-i', '-j', '-l', '-m', '-n', '-o', '-p', '-q',
  \   '-r', '-s', '-t', '-u', '-v', '-w', '-x',
  \   '--after-context',      '--before-context',
  \   '--case-sensitive',     '--color',
  \   '--colors',             '--column',
  \   '--context',            '--context-separator',
  \   '--count',              '--debug',
  \   '--dfa-size-limit',     '--encoding',
  \   '--file',               '--files',
  \   '--files-with-matches', '--files-without-match',
  \   '--fixed-strings',      '--follow',
  \   '--glob',               '--heading',
  \   '--help',               '--hidden',
  \   '--iglob',              '--ignore-case',
  \   '--ignore-file',        '--invert-match',
  \   '--line-number',        '--line-regexp',
  \   '--max-columns',        '--max-count',
  \   '--max-filesize',       '--maxdepth',
  \   '--mmap',               '--no-filename',
  \   '--no-heading',         '--no-ignore',
  \   '--no-ignore-parent',   '--no-ignore-vcs',
  \   '--no-line-number',     '--no-messages',
  \   '--no-mmap',            '--null',
  \   '--only-matching',      '--path-separator',
  \   '--pretty',             '--quiet',
  \   '--regex-size-limit',   '--regexp',
  \   '--replace',            '--smart-case',
  \   '--sort-files',         '--text',
  \   '--threads',            '--type',
  \   '--type-add',           '--type-clear',
  \   '--type-list',          '--type-not',
  \   '--unrestricted',       '--version',
  \   '--vimgrep',            '--with-filename',
  \   '--word-regexp',
  \ ]

  let words = split(a:cmdline, '\s\+', 1)

  if empty(words[-1])
    return ret
  elseif words[-1] =~# '^-\+\(\w\|-\)*$'
    return filter(ret, 'stridx(v:val, words[-1]) == 0')
  else
    return []
  endif
endfunction

" command! -nargs=+ -buffer -complete=customlist,my#complete#ripgrep RG grep! <q-args>
