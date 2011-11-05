" Test Esubst with file wildcards in the text part. 

source helpers/NumAndFile.vim
call vimtest#StartTap()
call vimtap#Plan(13)

" Tests that the ? wildcard is recognized in the text part. 
edit foobar.txt
Esubst f??b?r=lala
call vimtap#file#IsFilename('lala.txt', 'foobar -> Esubst ?= -> lala')
call vimtap#file#IsFile('foobar -> Esubst ?= -> lala')

" Tests that the * wildcard is recognized in the text part. 
edit foobar.txt
Esubst f*r=lala t*=install
call vimtap#file#IsFilename('lala.install', 'foobar.txt -> Esubst *= -> lala.install')
call vimtap#file#IsFile('foobar.txt -> Esubst *= -> lala.install')

" Tests that the ** wildcard is recognized in the text part. 
edit 001/production/prod666.txt
Esubst prod666=foobar EditSimilar/**/=EditSimilar/
call vimtap#file#IsFilename('foobar.txt', '001/production/prod666 -> Esubst **= -> foobar.txt')
call vimtap#file#IsFile('001/production/prod666 -> Esubst **= -> foobar.txt')
execute 'cd' expand('<sfile>:p:h')

" Tests that the [ch] wildcard is recognized in the text part. 
edit foobar.txt
Esubst [opq]o=XX [rs]=z
call vimtap#file#IsFilename('fXXbaz.txt', 'foobar -> Esubst []= -> fXXbaz')
call vimtap#file#IsFile('foobar -> Esubst []= -> fXXbaz')

" Tests that the [^ch] wildcard is recognized in the text part. 
edit file011.txt
Esubst file=f 0= [^a-z.]=o .txt=bar.txt
call vimtap#file#IsFilename('foobar.txt', 'file011 -> Esubst [^]= -> foobar')
call vimtap#file#IsFile('file011 -> Esubst [^]= -> foobar')

" Tests that the [ch] wildcard is taken literally if such a file exists. 
edit file[abc].txt
Esubst [abc]=003
call vimtap#file#IsFilename('file003.txt', 'file[abc] -> Esubst []= -> file003')
call vimtap#file#IsFile('file[abc] -> Esubst []= -> file003')

" Tests error that file pattern substitutes nothing. 
edit foobar.txt
echomsg 'Test: z* nothing substituted'
Esubst z*=lala
call vimtap#file#IsFilename('foobar.txt', 'foobar -> Esubst *= H> lala')

call vimtest#Quit()

