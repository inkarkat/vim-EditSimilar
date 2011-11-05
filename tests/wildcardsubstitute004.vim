" Test Esubst with ** file wildcards in the text part. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(7)

" Tests that the ** wildcard is recognized in the text part. 
edit 001/production/prod666.txt
Esubst prod666=foobar EditSimilar/**/=EditSimilar/
call vimtap#file#IsFilespec('EditSimilar/foobar.txt', '001/production/prod666 -> Esubst **= -> foobar.txt')
call vimtap#file#IsFile('001/production/prod666 -> Esubst **= -> foobar.txt')
execute 'cd' expand('<sfile>:p:h')

" Tests that the ** wildcard is only recognized when anchored at a path
" separator.  
edit 001/production/prod666.txt
echo 'Test: Nothing substituted when ...**' 
Esubst EditSimilar**=EditSimilar
call vimtap#file#IsFilename('prod666.txt', '001/production/prod666 -> Esubst **= H> foobar.txt')
execute 'cd' expand('<sfile>:p:h')

edit 001/production/prod666.txt
echo 'Test: Wildcard interpreted as * * when **...'
Esubst **tion=EditSimilar
call vimtap#file#IsFilename('prod666.txt', '001/production/prod666 -> Esubst **= H> foobar.txt')
execute 'cd' expand('<sfile>:p:h')

" Tests that the ** wildcard stops at the last path separator. 
edit 001/production/prod666.txt
Esubst prod666=foobar EditSimilar/**=EditSimilar
call vimtap#file#IsFilespec('EditSimilar/foobar.txt', '001/production/prod666 -> Esubst **= -> foobar.txt')
call vimtap#file#IsFile('001/production/prod666 -> Esubst **= -> foobar.txt')
execute 'cd' expand('<sfile>:p:h')

" Tests that a sole ** wildcard eats up the entire pathspec. 
edit 001/production/prod666.txt
echo 'Test: Sole ** wildcard eats up entire pathspec'
Esubst **=/foo
Esubst! **=/tmp
call vimtap#file#IsFilespec('/tmp/prod666.txt', '001/production/prod666 -> Esubst **= -> /tmp/prod666.txt')
execute 'cd' expand('<sfile>:p:h')

call vimtest#Quit()

