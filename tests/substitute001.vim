" Test Esubstitute. 

source helpers/NumAndFile.vim
call vimtest#StartTap(expand('<sfile>'))
call vimtap#Plan(13)

" Tests that substitution is performed multiple times (o=X). 
" Tests that multiple substitutions are performed. 
edit foobar.txt
Esubstitute o=X bar=baz
call vimtap#file#IsFilename('fXXbaz.txt', 'foobar -> Esubstitute -> fXXbaz')
call IsFile('foobar -> Esubstitute -> fXXbaz')
Esubstitute z=r X=o
call vimtap#file#IsFilename('foobar.txt', 'fXXbaz -> Esubstitute -> foobar')
call IsFile('fXXbaz -> Esubstitute -> foobar')

" Tests error that substituted file does not exist. 
echomsg 'foxbar.txt does not exist'
Esubstitute foo=fox
call vimtap#file#IsFilename('foobar.txt', 'foobar -> Esubstitute H> foxbar')

" Tests that bang creates file. 
Esubstitute! foo=fox
call vimtap#file#IsFilename('foxbar.txt', 'foobar -> Esubstitute! -> foxbar')
call IsNoFile('foobar -> Esubstitute! -> foxbar')

" Tests that substitutions are done sequentially from left to right. 
edit foobar.txt
Esubstitute! o=X X=Y Y=OO
call vimtap#file#IsFilename('fOOOObar.txt', 'foobar -> Esubstitute! -> fOOOObar')
edit foobar.txt
Esubstitute! Y=OO X=Y o=X
call vimtap#file#IsFilename('fXXbar.txt', 'foobar -> Esubstitute! H> fXXbar')


" Tests that only the filename is substituted if everything matches there. 
execute 'cd' expand('<sfile>:p:h')
edit 001/dev/dev001.txt
Esubstitute 001=002
call vimtap#file#IsFilespec('001/dev/dev002.txt', '001 -> Esubstitute -> 002')

" Tests that the absolute pathspec is substituted if not everything matched in
" the filename. 
execute 'cd' expand('<sfile>:p:h')
edit 001/production/prod666.txt
Esubstitute 666=001 production=prod
call vimtap#file#IsFilespec('001/prod/prod001.txt', 'production/prod666 -> Esubstitute -> prod/prod001')

" Tests that the filename is not substituted again when the pathspec is
" processed. 
execute 'cd' expand('<sfile>:p:h')
edit 001/production/prod666.txt
Esubstitute! 001=002 666=001 production=dev prod=dev
call vimtap#file#IsFilespec('002/dev/dev001.txt', '001/production/prod666 -> Esubstitute -> 002/dev/dev001.txt')
call IsNoFile('001/production/prod666 -> Esubstitute -> 002/dev/dev001.txt')

call vimtest#Quit()

