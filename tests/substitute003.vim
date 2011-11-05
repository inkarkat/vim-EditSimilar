" Test Esubst with spaces. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(4)

" Tests replacement with spaces. 
edit foobar.txt
Esubst! bar=b\ r foo=foo\ 
call vimtap#file#IsFilename('foo b r.txt', 'foobar -> Esubst! -> foo b r')
call vimtap#file#IsNoFile('foobar -> Esubst! -> foo b r')

" Tests text with spaces. 
Esubst b\ r=bar oo\ =oo
call vimtap#file#IsFilename('foobar.txt', 'foo b r -> Esubst -> foobar')
call vimtap#file#IsFile('foo b r -> Esubst -> foobar')

call vimtest#Quit()

