" Test check of wildcard path pattern.

call vimtest#StartTap()
call vimtap#Plan(10)
cd testdata

function! s:Is( input, expected, description )
    call vimtap#Is(ingo#regexp#fromwildcard#IsWildcardPathPattern(a:input), a:expected, a:description)
endfunction

let s:PS = (exists('+shellslash') && ! &shellslash ? '\' : '/')

call s:Is('foobar', 0, 'plain text')
call s:Is(printf('foo%sbar', s:PS), 1, 'simple path')
call s:Is(printf('%sfoo%sbar%s', s:PS, s:PS, s:PS), 1, 'long path')
if ! vimtap#Skip(1, (exists('+shellslash') && ! &shellslash), 'backslash path separator')
    call s:Is('foo/bar', 1, 'forward-slash path separator')
endif

call s:Is('f??b*r', 0, '?* wildcard text')
call s:Is('f[opq]b[^x]r', 0, '[] wildcard text')
call s:Is('f[abc/\\xyz]b[^x**]r', 0, '[/\**] wildcard text')

call s:Is(printf('**%sfoo', s:PS), 1, '**/... wildcard text')
call s:Is(printf('foo%s**', s:PS), 1, '.../** wildcard text')
call s:Is('**', 1, 'only ** wildcard text')

call vimtest#Quit()
