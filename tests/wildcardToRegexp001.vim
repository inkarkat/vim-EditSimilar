" Test conversion of file wildcards to regexp. 

runtime plugin/SidTools.vim
runtime autoload/EditSimilar.vim

call vimtest#StartTap()
call vimtap#Plan(14)

let s:SID = Sid('autoload/EditSimilar.vim')
function! s:Is( input, expectedRegexp, description )
    let l:gotRegexp = SidInvoke(s:SID, printf("WildcardToRegexp('%s')", a:input))
    call vimtap#Is(l:gotRegexp, a:expectedRegexp, a:description)
endfunction

call s:Is('foobar', '\Vfoobar', 'no wildcards')
call s:Is('f??b?r', '\Vf\.\.b\.r', '? wildcards')
call s:Is('f??b\?r', '\Vf\.\.b?r', '? literal')
call s:Is('f*b*', '\Vf\.\*b\.\*', '* wildcards')
call s:Is('f\*\*b*', '\Vf**b\.\*', '* literal')
call s:Is('f*b?r', '\Vf\.\*b\.r', '? and * wildcards')
call s:Is('f[opq][opq]bar', '\Vf\%(\[opq]\|[opq]\)\%(\[opq]\|[opq]\)bar', '[] wildcards')
call s:Is('foob[^xyz]r', '\Vfoob\%(\[^xyz]\|[^xyz]\)r', '[^] wildcards')
call s:Is('foob[r', '\Vfoob[r', '[ literal')
call s:Is('foob]r', '\Vfoob]r', '] literal')
call s:Is('foob[[abc]r', '\Vfoob\%(\[[abc]\|[[abc]\)r', '[[] wildcards')
call s:Is('foob[]abc]r', '\Vfoob\%(\[]abc]\|[]abc]\)r', '[]] wildcards')
call s:Is('foob[^]abc]r', '\Vfoob\%(\[^]abc]\|[^]abc]\)r', '[^]] wildcards')
call s:Is('foob[ab\]c]r', '\Vfoob\%(\[ab\]c]\|[ab\]c]\)r', '[]] wildcards')

call vimtest#Quit()

