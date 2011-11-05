" Test Esubst bad invocations. 

edit foobar.txt
echomsg 'Test: no arguments'
Esubst
echomsg 'Test: not a substitution'
Esubst foo
echomsg 'Test: one is not a substitution'
Esubst foo=fox XX=YY ?lala?
echomsg 'Test: substitution source must not be empty'
Esubst =fox

" Tests nothing substituted. 
echomsg 'Test: Nothing substituted'
Esubst foo=foo x=x

call vimtest#Quit()

