" Test EditSubstitute bad invocations.

cd testdata

edit foobar.txt
echomsg 'Test: no arguments'
EditSubstitute
echomsg 'Test: not a substitution'
EditSubstitute foo
echomsg 'Test: one is not a substitution'
EditSubstitute foo=fox XX=YY ?lala?
echomsg 'Test: substitution source must not be empty'
EditSubstitute =fox

" Tests nothing substituted.
echomsg 'Test: Nothing substituted'
EditSubstitute foo=foo x=x

call vimtest#Quit()
