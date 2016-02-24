" Test BDeletePattern.

source helpers/Buffers.vim
call vimtest#StartTap()
call vimtap#Plan(2)
cd testdata

edit lala.txt
edit file100.txt
edit file005.txt
edit file004.txt
call IsBuffers(['file004.txt', 'file005.txt', 'file100.txt', 'lala.txt'], 'all buffers')

BDeletePattern file*.txt
call IsBuffers(['lala.txt'], 'BDeletePattern file*.txt')
call IsNameAndFile('lala.txt', 'current buffer changed after :BDeletePattern')

call vimtest#Quit()
