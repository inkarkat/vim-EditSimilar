" Test EditPlus with options and +cmd.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(7)
cd testdata

set nobinary nowrap wrapmargin=0
edit file004.txt
2EditPlus ++bin ++bad=drop +setl\ wrap\|echomsg\ 'open'\ expand('%')
call IsNameAndFile('file006.txt', '2EditPlus ...')
call vimtap#Is(&l:wrap, 1, 'wrap enabled')
call vimtap#Is(&l:binary, 1, 'binary enabled')

EditPlus +setl\ wrapmargin=33\|echomsg\ 'open'\ expand('%') 5
call IsNameAndFile('file011.txt', 'EditPlus ... 5')
call vimtap#Is(&l:wrapmargin, 33, 'wrapmargin set')

call vimtest#Quit()
