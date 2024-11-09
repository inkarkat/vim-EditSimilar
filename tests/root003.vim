" Test EditRoot with wildcards in extension.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(11)
cd testdata

edit foobar.txt
EditRoot c??
call IsNameAndFile('foobar.cpp', 'EditRoot c??')

edit lala.txt
EditRoot des*on
call IsNameAndFile('lala.description', 'EditRoot des*on')

edit lala.txt
call vimtap#err#Errors('Too many file names', 'EditRoot *i*', 'non-unique extension glob')
call IsNameAndFile('lala.txt', 'EditRoot *i*')

edit foobar.txt
EditRoot! t\?\?
call IsNameAndNoFile('foobar.t??', 'EditRoot! t\?\?')

edit foobar.txt
EditRoot! \*#\*
call IsNameAndNoFile('foobar.*#*', 'EditRoot! \*#\*')

call vimtest#Quit()
