function! my#tmp#combination(ary, ...) abort
  let ret = []
  let i = 1
  let uniq = get(a:000, 1, 0)
  for s:value in a:ary
    for s:value2 in a:ary[i:-1]
      call add(ret, [s:value, s:value2])
    endfor
    let i = i + 1
  endfor

  if uniq
    return uniq(ret)
  else
    return ret
  endif
endfunction

" fizzbuzz
function! my#tmp#fizzbuzz(count) abort
  for s:num in range(a:count + 1)
    if (s:num % 3) == 0 && (s:num % 5) == 0
      echo 'FizzBuzz'
    elseif (s:num % 3) == 0
      echo 'Fizz'
    elseif (s:num % 5) == 0
      echo 'Buzz'
    else
      echo s:num
    endif
  endfor
endfunction

" https://teratail.com/questions/11046
function! my#tmp#cannibals_problem() abort
  let src = ["○","○","○","●","●","●","□"]
  let dst = []
endfunction

function! my#tmp#cannibals_problem_check() abort
endfunction
