" Test EditSubstitute with ** file wildcards in the text part.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(10)
execute 'cd' expand('<sfile>:p:h') . '/testdata'

" Tests that the ** wildcard is recognized in the text part.
edit 001/production/prod666.txt
EditSubstitute prod666=foobar testdata/**/=testdata/
call vimtap#file#IsFilespec('testdata/foobar.txt', '001/production/prod666 -> EditSubstitute **= -> foobar.txt')
call vimtap#file#IsFile('001/production/prod666 -> EditSubstitute **= -> foobar.txt')
execute 'cd' expand('<sfile>:p:h') . '/testdata'

" Tests that the ** wildcard is only recognized when anchored at a path
" separator.
edit 001/production/prod666.txt
call vimtap#err#Errors('Nothing substituted', 'EditSubstitute testdata**=testdata', 'Nothing substituted when ...**')
call vimtap#file#IsFilename('prod666.txt', '001/production/prod666 -> EditSubstitute **= H> foobar.txt')
execute 'cd' expand('<sfile>:p:h') . '/testdata'

edit 001/production/prod666.txt
call vimtap#err#ErrorsLike('Substituted file does not exist (add ! to create): 001[/\\]testdata[/\\]prod666.txt', 'EditSubstitute **tion=testdata', 'Wildcard interpreted as * * when **...')
call vimtap#file#IsFilename('prod666.txt', '001/production/prod666 -> EditSubstitute **= H> foobar.txt')
execute 'cd' expand('<sfile>:p:h') . '/testdata'

" Tests that the ** wildcard stops at the last path separator.
edit 001/production/prod666.txt
EditSubstitute prod666=foobar testdata/**=testdata
call vimtap#file#IsFilespec('testdata/foobar.txt', '001/production/prod666 -> EditSubstitute **= -> foobar.txt')
call vimtap#file#IsFile('001/production/prod666 -> EditSubstitute **= -> foobar.txt')
execute 'cd' expand('<sfile>:p:h') . '/testdata'

" Tests that a sole ** wildcard eats up the entire pathspec.
edit 001/production/prod666.txt
call vimtap#err#ErrorsLike('Substituted file does not exist (add ! to create): [/\\]foo[/\\]prod666.txt', 'EditSubstitute **=/foo', 'Sole ** wildcard eats up entire pathspec')
EditSubstitute! **=/tmp
call vimtap#file#IsFilespec('/tmp/prod666.txt', '001/production/prod666 -> EditSubstitute **= -> /tmp/prod666.txt')
execute 'cd' expand('<sfile>:p:h') . '/testdata'

call vimtest#Quit()
