" Test conversion of file wildcards to regexp. 

runtime plugin/SidTools.vim
runtime autoload/EditSimilar.vim

call vimtest#StartTap()
call vimtap#Plan(21)

let s:SID = Sid('autoload/EditSimilar.vim')
function! s:Is( input, expectedRegexp, description )
    let l:gotRegexp = SidInvoke(s:SID, printf("WildcardToRegexp('%s')", a:input))
    call vimtap#Is(l:gotRegexp, a:expectedRegexp, a:description)
endfunction

let s:NPS = (exists('+shellslash') && ! &shellslash ? '\[^/\\]' : '\[^/]')
let s:PS = (exists('+shellslash') && ! &shellslash ? '\\' : '/')

call s:Is('foobar', '\Vfoobar', 'no wildcards')

call s:Is('f??b?r',	printf('\Vf%s%sb%sr', s:NPS, s:NPS, s:NPS), '? wildcards')
call s:Is('f??b\?r',	printf('\Vf%s%sb?r', s:NPS, s:NPS), '? literal')

call s:Is('f*b*',	printf('\Vf%s\*b%s\*', s:NPS, s:NPS), '* wildcards')
call s:Is('f\*\*b*',	printf('\Vf**b%s\*', s:NPS), '* literal')
call s:Is('f*b?r',  	printf('\Vf%s\*b%sr', s:NPS, s:NPS), '? and * wildcards')

call s:Is('**/b*',	printf('\V\.\{0,}%sb%s\*', s:PS, s:NPS), '** wildcard at start')
call s:Is('f/**/b*',	printf('\Vf%s\.\{0,}%sb%s\*', s:PS, s:PS, s:NPS), '** wildcard in between')
call s:Is('f/**',	printf('\Vf%s\.\{0,}%s', s:PS, (s:PS == '\\' ? '\%(\\\)\@=' : s:PS . '\@=')), '** wildcard at end')
call s:Is('**',		printf('\V\^\.\{0,}%s', (s:PS == '\\' ? '\%(\\\)\@=' : s:PS . '\@=')), 'only ** wildcard')
if ! vimtap#Skip(1, (! exists('+shellslash') || &shellslash), 'forward slash path separator')
    call s:Is('f\**b*',	printf('\Vf**b%s\*', s:NPS), '** literal')
endif

call s:Is('f[opq][opq]bar', '\Vf\%(\%(\[opq]\&' . s:NPS . '\)\|[opq]\)\%(\%(\[opq]\&' . s:NPS . '\)\|[opq]\)bar', '[] wildcards')
call s:Is('foob[^xyz]r',    '\Vfoob\%(\%(\[^xyz]\&' . s:NPS . '\)\|[^xyz]\)r', '[^] wildcards')
call s:Is('foob[r',	    '\Vfoob[r', '[ literal')
call s:Is('foob]r',	    '\Vfoob]r', '] literal')
call s:Is('foob[[abc]r',    '\Vfoob\%(\%(\[[abc]\&' . s:NPS . '\)\|[[abc]\)r', '[[] wildcards')
call s:Is('foob[]abc]r',    '\Vfoob\%(\%(\[]abc]\&' . s:NPS . '\)\|[]abc]\)r', '[]] wildcards')
call s:Is('foob[^]abc]r',   '\Vfoob\%(\%(\[^]abc]\&' . s:NPS . '\)\|[^]abc]\)r', '[^]] wildcards')
call s:Is('foob[ab\]c]r',   '\Vfoob\%(\%(\[ab\]c]\&' . s:NPS . '\)\|[ab\]c]\)r', '[]] wildcards')

call s:Is('[fgh]*b?r', '\V\%(\%(\[fgh]\&' . s:NPS . '\)\|[fgh]\)' . printf('%s\*b%sr', s:NPS, s:NPS), '?, * and [] wildcards')
call s:Is('foob[x*?y]r',    '\Vfoob\%(\%(\[x*?y]\&' . s:NPS . '\)\|[x*?y]\)r', '[*?] wildcards')

call vimtest#Quit()

