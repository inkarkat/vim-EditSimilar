" Test EditNext with options and +cmd.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(4)
cd testdata

set nobinary nowrap
edit file100.txt

EditNext ++bin ++bad=drop +setl\ wrap\|echomsg\ 'open'\ expand('\%')
call IsNameAndFile('file101.txt', 'EditNext ...')
call vimtap#Is(&l:wrap, 1, 'wrap enabled')
call vimtap#Is(&l:binary, 1, 'binary enabled')

call vimtest#Quit()
