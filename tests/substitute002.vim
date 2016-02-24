" Test EditSubstitute bad invocations.

cd testdata

edit foobar.txt
call vimtest#StartTap()
call vimtap#Plan(5)

call vimtap#err#ErrorsLike('E471: .* EditSubstitute', 'EditSubstitute', 'no arguments')
call vimtap#err#Errors('Not a substitution: foo', 'EditSubstitute foo', 'not a substitution')
call vimtap#err#Errors('Not a substitution: ?lala?', 'EditSubstitute foo=fox XX=YY ?lala?', 'one is not a substitution')
call vimtap#err#Errors('Not a substitution: =fox', 'EditSubstitute =fox', 'substitution source must not be empty')

" Tests nothing substituted.
call vimtap#err#Errors('Nothing substituted', 'EditSubstitute foo=foo x=x', 'error')

call vimtest#Quit()
