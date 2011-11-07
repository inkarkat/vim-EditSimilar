" Test EditSubstitute. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(15)

" Tests that substitution is performed multiple times (o=X). 
" Tests that multiple substitutions are performed. 
edit foobar.txt
EditSubstitute o=X bar=baz
call vimtap#file#IsFilename('fXXbaz.txt', 'foobar -> EditSubstitute -> fXXbaz')
call vimtap#file#IsFile('foobar -> EditSubstitute -> fXXbaz')
EditSubstitute z=r X=o
call vimtap#file#IsFilename('foobar.txt', 'fXXbaz -> EditSubstitute -> foobar')
call vimtap#file#IsFile('fXXbaz -> EditSubstitute -> foobar')

" Tests error that substituted file does not exist. 
echomsg 'Test: foxbar.txt does not exist'
EditSubstitute foo=fox
call vimtap#file#IsFilename('foobar.txt', 'foobar -> EditSubstitute H> foxbar')

" Tests that bang creates file. 
EditSubstitute! foo=fox
call vimtap#file#IsFilename('foxbar.txt', 'foobar -> EditSubstitute! -> foxbar')
call vimtap#file#IsNoFile('foobar -> EditSubstitute! -> foxbar')

" Tests that something can be substituted away. 
edit foobar.txt
EditSubstitute! foo= bar=baz
call vimtap#file#IsFilename('baz.txt', 'foobar -> EditSubstitute! -> baz')
call vimtap#file#IsNoFile('foobar -> EditSubstitute! -> baz')

" Tests that substitutions are done sequentially from left to right. 
edit foobar.txt
EditSubstitute! o=X X=Y Y=OO
call vimtap#file#IsFilename('fOOOObar.txt', 'foobar -> EditSubstitute! -> fOOOObar')
edit foobar.txt
EditSubstitute! Y=OO X=Y o=X
call vimtap#file#IsFilename('fXXbar.txt', 'foobar -> EditSubstitute! H> fXXbar')


" Tests that only the filename is substituted if everything matches there. 
execute 'cd' expand('<sfile>:p:h')
edit 001/dev/dev001.txt
EditSubstitute 001=002
call vimtap#file#IsFilespec('001/dev/dev002.txt', '001 -> EditSubstitute -> 002')

" Tests that the absolute pathspec is substituted if not everything matched in
" the filename. 
execute 'cd' expand('<sfile>:p:h')
edit 001/production/prod666.txt
EditSubstitute 666=001 production=prod
call vimtap#file#IsFilespec('001/prod/prod001.txt', 'production/prod666 -> EditSubstitute -> prod/prod001')

" Tests that the filename is not substituted again when the pathspec is
" processed. 
execute 'cd' expand('<sfile>:p:h')
edit 001/production/prod666.txt
EditSubstitute! 001=002 666=001 production=dev prod=dev
call vimtap#file#IsFilespec('002/dev/dev001.txt', '001/production/prod666 -> EditSubstitute -> 002/dev/dev001.txt')
call vimtap#file#IsNoFile('001/production/prod666 -> EditSubstitute -> 002/dev/dev001.txt')

" Tests that only the filename is printed in the error when everything matches there. 
execute 'cd' expand('<sfile>:p:h')
edit 001/dev/dev001.txt
cd $VIM
echomsg 'Test: foo123 does not exist'
EditSubstitute 001=123 dev=foo

" Tests that the shortened filespec is printed in the error when the match is in
" the pathspec. 
execute 'cd' expand('<sfile>:p:h')
edit 001/production/prod666.txt
cd $VIM
echomsg 'Test: new/fox456 does not exist'
EditSubstitute prod=fox 666=456 production=new
execute 'cd' expand('<sfile>:p:h')
EditSubstitute prod=fox 666=456 production=new

call vimtest#Quit()
