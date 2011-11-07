" Test EditSubstitute with ** file wildcards in the text part. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(7)

" Tests that the ** wildcard is recognized in the text part. 
edit 001/production/prod666.txt
EditSubstitute prod666=foobar EditSimilar/**/=EditSimilar/
call vimtap#file#IsFilespec('EditSimilar/foobar.txt', '001/production/prod666 -> EditSubstitute **= -> foobar.txt')
call vimtap#file#IsFile('001/production/prod666 -> EditSubstitute **= -> foobar.txt')
execute 'cd' expand('<sfile>:p:h')

" Tests that the ** wildcard is only recognized when anchored at a path
" separator.  
edit 001/production/prod666.txt
echo 'Test: Nothing substituted when ...**' 
EditSubstitute EditSimilar**=EditSimilar
call vimtap#file#IsFilename('prod666.txt', '001/production/prod666 -> EditSubstitute **= H> foobar.txt')
execute 'cd' expand('<sfile>:p:h')

edit 001/production/prod666.txt
echo 'Test: Wildcard interpreted as * * when **...'
EditSubstitute **tion=EditSimilar
call vimtap#file#IsFilename('prod666.txt', '001/production/prod666 -> EditSubstitute **= H> foobar.txt')
execute 'cd' expand('<sfile>:p:h')

" Tests that the ** wildcard stops at the last path separator. 
edit 001/production/prod666.txt
EditSubstitute prod666=foobar EditSimilar/**=EditSimilar
call vimtap#file#IsFilespec('EditSimilar/foobar.txt', '001/production/prod666 -> EditSubstitute **= -> foobar.txt')
call vimtap#file#IsFile('001/production/prod666 -> EditSubstitute **= -> foobar.txt')
execute 'cd' expand('<sfile>:p:h')

" Tests that a sole ** wildcard eats up the entire pathspec. 
edit 001/production/prod666.txt
echo 'Test: Sole ** wildcard eats up entire pathspec'
EditSubstitute **=/foo
EditSubstitute! **=/tmp
call vimtap#file#IsFilespec('/tmp/prod666.txt', '001/production/prod666 -> EditSubstitute **= -> /tmp/prod666.txt')
execute 'cd' expand('<sfile>:p:h')

call vimtest#Quit()
