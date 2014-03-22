" Test BDeleteNext.

source helpers/Buffers.vim
call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

edit lala.txt
edit file100.txt
edit file005.txt
edit file004.txt
call IsBuffers(['file004.txt', 'file005.txt', 'file100.txt', 'lala.txt'], 'all buffers')

BDeleteNext
call IsBuffers(['file004.txt', 'file100.txt', 'lala.txt'], 'BDeleteNext')
999BDeleteNext
call IsBuffers(['file004.txt', 'file100.txt'], '999BDeleteNext')

echomsg 'Test: second 999BDeleteNext'
999BDeleteNext
call IsBuffers(['file004.txt', 'file100.txt'], 'second 999BDeleteNext')

call vimtest#Quit()
