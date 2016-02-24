" Test EditSubstitute with file wildcards in the text part.

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(14)
cd testdata

" Tests that the ? wildcard is recognized in the text part.
edit foobar.txt
EditSubstitute f??b?r=lala
call vimtap#file#IsFilename('lala.txt', 'foobar -> EditSubstitute ?= -> lala')
call vimtap#file#IsFile('foobar -> EditSubstitute ?= -> lala')

" Tests that the * wildcard is recognized in the text part.
edit foobar.txt
EditSubstitute f*r=lala t*=install
call vimtap#file#IsFilename('lala.install', 'foobar.txt -> EditSubstitute *= -> lala.install')
call vimtap#file#IsFile('foobar.txt -> EditSubstitute *= -> lala.install')

" Tests that the ** wildcard is recognized in the text part.
edit 001/production/prod666.txt
EditSubstitute prod666=foobar testdata/**/=testdata/
call vimtap#file#IsFilename('foobar.txt', '001/production/prod666 -> EditSubstitute **= -> foobar.txt')
call vimtap#file#IsFile('001/production/prod666 -> EditSubstitute **= -> foobar.txt')
execute 'cd' expand('<sfile>:p:h') . '/testdata'

" Tests that the [ch] wildcard is recognized in the text part.
edit foobar.txt
EditSubstitute [opq]o=CC [rs]=z
call vimtap#file#IsFilename('fCCbaz.txt', 'foobar -> EditSubstitute []= -> fCCbaz')
call vimtap#file#IsFile('foobar -> EditSubstitute []= -> fCCbaz')

" Tests that the [^ch] wildcard is recognized in the text part.
edit file011.txt
EditSubstitute file=f 0= [^a-z.]=o .txt=bar.txt
call vimtap#file#IsFilename('foobar.txt', 'file011 -> EditSubstitute [^]= -> foobar')
call vimtap#file#IsFile('file011 -> EditSubstitute [^]= -> foobar')

" Tests that the [ch] wildcard is taken literally if such a file exists.
edit file[abc].txt
EditSubstitute [abc]=003
call vimtap#file#IsFilename('file003.txt', 'file[abc] -> EditSubstitute []= -> file003')
call vimtap#file#IsFile('file[abc] -> EditSubstitute []= -> file003')

" Tests error that file pattern substitutes nothing.
edit foobar.txt
call vimtap#err#Errors('Nothing substituted', 'EditSubstitute z*=lala', 'error')
call vimtap#file#IsFilename('foobar.txt', 'foobar -> EditSubstitute *= H> lala')

call vimtest#Quit()
