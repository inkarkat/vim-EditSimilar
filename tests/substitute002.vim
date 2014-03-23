" Test EditSubstitute bad invocations.

cd testdata

edit foobar.txt
call vimtest#StartTap()
call vimtap#Plan(5)

try
    EditSubstitute
    call vimtap#Fail('expected error')
catch
    call vimtap#err#ThrownLike('E471: .* EditSubstitute', 'no arguments')
endtry
try
    EditSubstitute foo
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Not a substitution: foo', 'not a substitution')
endtry
try
    EditSubstitute foo=fox XX=YY ?lala?
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Not a substitution: ?lala?', 'one is not a substitution')
endtry
try
    EditSubstitute =fox
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Not a substitution: =fox', 'substitution source must not be empty')
endtry

" Tests nothing substituted.
try
    EditSubstitute foo=foo x=x
    call vimtap#Fail('expected error')
catch
    call vimtap#err#Thrown('Nothing substituted', 'error')
endtry

call vimtest#Quit()
