" Test EditSubstitute with spaces. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(4)

" Tests replacement with spaces. 
edit foobar.txt
EditSubstitute! bar=b\ r foo=foo\ 
call vimtap#file#IsFilename('foo b r.txt', 'foobar -> EditSubstitute! -> foo b r')
call vimtap#file#IsNoFile('foobar -> EditSubstitute! -> foo b r')

" Tests text with spaces. 
EditSubstitute b\ r=bar oo\ =oo
call vimtap#file#IsFilename('foobar.txt', 'foo b r -> EditSubstitute -> foobar')
call vimtap#file#IsFile('foo b r -> EditSubstitute -> foobar')

call vimtest#Quit()
