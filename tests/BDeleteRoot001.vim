" Test BDeleteRoot.

source helpers/Buffers.vim
call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

edit lala.txt
edit file100.txt
edit foobar.cpp
edit foobar.txt
call IsBuffers(['foobar.txt', 'foobar.cpp', 'file100.txt', 'lala.txt'], 'all buffers')

BDeleteRoot cpp
call IsBuffers(['foobar.txt', 'file100.txt', 'lala.txt'], 'BDeleteNext')

call vimtap#err#Errors('Nothing substituted', 'BDeleteRoot txt', 'error')
call IsBuffers(['foobar.txt', 'file100.txt', 'lala.txt'], 'BDeleteNext')

call vimtest#Quit()
