" Test Esubst. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(15)

" Tests that substitution is performed multiple times (o=X). 
" Tests that multiple substitutions are performed. 
edit foobar.txt
Esubst o=X bar=baz
call vimtap#file#IsFilename('fXXbaz.txt', 'foobar -> Esubst -> fXXbaz')
call vimtap#file#IsFile('foobar -> Esubst -> fXXbaz')
Esubst z=r X=o
call vimtap#file#IsFilename('foobar.txt', 'fXXbaz -> Esubst -> foobar')
call vimtap#file#IsFile('fXXbaz -> Esubst -> foobar')

" Tests error that substituted file does not exist. 
echomsg 'Test: foxbar.txt does not exist'
Esubst foo=fox
call vimtap#file#IsFilename('foobar.txt', 'foobar -> Esubst H> foxbar')

" Tests that bang creates file. 
Esubst! foo=fox
call vimtap#file#IsFilename('foxbar.txt', 'foobar -> Esubst! -> foxbar')
call vimtap#file#IsNoFile('foobar -> Esubst! -> foxbar')

" Tests that something can be substituted away. 
edit foobar.txt
Esubst! foo= bar=baz
call vimtap#file#IsFilename('baz.txt', 'foobar -> Esubst! -> baz')
call vimtap#file#IsNoFile('foobar -> Esubst! -> baz')

" Tests that substitutions are done sequentially from left to right. 
edit foobar.txt
Esubst! o=X X=Y Y=OO
call vimtap#file#IsFilename('fOOOObar.txt', 'foobar -> Esubst! -> fOOOObar')
edit foobar.txt
Esubst! Y=OO X=Y o=X
call vimtap#file#IsFilename('fXXbar.txt', 'foobar -> Esubst! H> fXXbar')


" Tests that only the filename is substituted if everything matches there. 
execute 'cd' expand('<sfile>:p:h')
edit 001/dev/dev001.txt
Esubst 001=002
call vimtap#file#IsFilespec('001/dev/dev002.txt', '001 -> Esubst -> 002')

" Tests that the absolute pathspec is substituted if not everything matched in
" the filename. 
execute 'cd' expand('<sfile>:p:h')
edit 001/production/prod666.txt
Esubst 666=001 production=prod
call vimtap#file#IsFilespec('001/prod/prod001.txt', 'production/prod666 -> Esubst -> prod/prod001')

" Tests that the filename is not substituted again when the pathspec is
" processed. 
execute 'cd' expand('<sfile>:p:h')
edit 001/production/prod666.txt
Esubst! 001=002 666=001 production=dev prod=dev
call vimtap#file#IsFilespec('002/dev/dev001.txt', '001/production/prod666 -> Esubst -> 002/dev/dev001.txt')
call vimtap#file#IsNoFile('001/production/prod666 -> Esubst -> 002/dev/dev001.txt')

" Tests that only the filename is printed in the error when everything matches there. 
execute 'cd' expand('<sfile>:p:h')
edit 001/dev/dev001.txt
cd $VIM
echomsg 'Test: foo123 does not exist'
Esubst 001=123 dev=foo

" Tests that the shortened filespec is printed in the error when the match is in
" the pathspec. 
execute 'cd' expand('<sfile>:p:h')
edit 001/production/prod666.txt
cd $VIM
echomsg 'Test: new/fox456 does not exist'
Esubst prod=fox 666=456 production=new
execute 'cd' expand('<sfile>:p:h')
Esubst prod=fox 666=456 production=new

call vimtest#Quit()

