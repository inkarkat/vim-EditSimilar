" Test EditRoot with space and special characters in extension.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(6)
cd testdata

edit foobar.txt
EditRoot! for\ me
call IsNameAndNoFile('foobar.for me', 'EditRoot! for\ me')

edit foobar.txt
EditRoot! %
call IsNameAndNoFile('foobar.%', 'EditRoot! %')

edit foobar.orig.txt
EditRoot! ..%%me##
call IsNameAndNoFile('foobar.%%me##', 'EditRoot! ..%%me##')

call vimtest#Quit()
