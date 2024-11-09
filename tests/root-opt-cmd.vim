" Test EditRoot with options and +cmd.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

set nobinary nowrap
edit foobar.txt
EditRoot ++bin ++bad=drop +setl\ wrap\|echomsg\ 'open'\ expand('%') cpp
call IsNameAndFile('foobar.cpp', 'EditRoot ... cpp')
call vimtap#Is(&l:wrap, 1, 'wrap enabled')
call vimtap#Is(&l:binary, 1, 'binary enabled')

call vimtest#Quit()
