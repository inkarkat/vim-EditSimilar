" Test BDeleteRoot.

source helpers/Buffers.vim
call vimtest#StartTap()
call vimtap#Plan(3)
cd testdata

edit lala.txt
edit file100.txt
edit foobar.cpp
edit foobar.txt
call IsBuffers(['foobar.txt', 'foobar.cpp', 'file100.txt', 'lala.txt'], 'all buffers')

BDeleteRoot cpp
call IsBuffers(['foobar.txt', 'file100.txt', 'lala.txt'], 'BDeleteNext')

echomsg 'Test: Nothing substituted'
BDeleteRoot txt
call IsBuffers(['foobar.txt', 'file100.txt', 'lala.txt'], 'BDeleteNext')

call vimtest#Quit()
