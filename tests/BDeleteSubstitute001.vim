" Test BDeleteSubstitute.

source helpers/Buffers.vim
call vimtest#StartTap()
call vimtap#Plan(2)
cd testdata

edit lala.txt
edit file100.txt
edit fCCbaz.txt
edit foobar.txt
call IsBuffers(['foobar.txt', 'fCCbaz.txt', 'file100.txt', 'lala.txt'], 'all buffers')

BDeleteSubstitute o=C bar=baz
call IsBuffers(['foobar.txt', 'file100.txt', 'lala.txt'], 'BDeleteSubstitute')

call vimtest#Quit()
